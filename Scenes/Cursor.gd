extends Node2D

onready var Grid = $MovementGrid
onready var sprite: AnimatedSprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer
onready var selections = $Selections
onready var rangeTiles = get_parent().get_node("RangeLayer")
onready var obstacleTiles = get_parent().get_node("ObstacleLayer")
onready var terrainLabel = get_parent().get_node("TerrainLabel")

var initialCharPosition
var inRangeEnemies = []
var hoveredCharacter = null
var selectedCharacter = null
var selection
onready var target_position = 0

class tileDictionary:
	var tileColors = {}
	
func _ready():
	Global.Cursor = self

func setTerrainLabel(type):
	terrainLabel.set_text(type)

func colorAttackTiles():
	var tilePosition = Grid.world_to_map(position)
	var tileColors = tileDictionary.new()
	floodFill(tileColors, tilePosition, selectedCharacter.attackRange)
	
	for key in tileColors.tileColors:
		var val = tileColors.tileColors[key]
		if val >= 0:
			rangeTiles.set_cellv(key,1)


func colorRangeTiles():
	var playerMovement = hoveredCharacter.movement
	var moveDistance = hoveredCharacter.movement + hoveredCharacter.attackRange
	var tilePosition = Grid.world_to_map(position)
	var tileColors = tileDictionary.new()
	floodFill(tileColors, tilePosition, moveDistance)
	rangeTiles.visible = true
	for key in tileColors.tileColors:
		var val = tileColors.tileColors[key]
		if val >= moveDistance - playerMovement:
			rangeTiles.set_cellv(key,0)
		else:
			rangeTiles.set_cellv(key,1)

# do color self tile first
func floodFill(tileDictionary,tilePosition, movement):
	var movementCost = obstacleTiles.getMovementCost(tilePosition)
	movement = movement - movementCost - 1
	
	if tileDictionary.tileColors.has(tilePosition):
		var currentValue = tileDictionary.tileColors[tilePosition]
		tileDictionary.tileColors[tilePosition] = max(currentValue, movement)
	else:
		tileDictionary.tileColors[tilePosition] = movement
	if(movement > 0):
		floodFill(tileDictionary, tilePosition + Vector2(1,0), movement)
		floodFill(tileDictionary, tilePosition - Vector2(1,0), movement) 
		floodFill(tileDictionary, tilePosition + Vector2(0,1), movement)
		floodFill(tileDictionary, tilePosition - Vector2(0,1), movement)
	return

func validMove():
	var pos = Vector2(position)
	var tilePos = rangeTiles.world_to_map(pos)
	return rangeTiles.get_cellv(tilePos) == 0

func moveCharacter():
	selectedCharacter.move_to(position)
	rangeTiles.visible = false


func playSelectSFX():
	$SelectSFX.play()

func playInvalidSFX():
	$InvalidSFX.play()

func playMoveSFX():
	$MoveSFX.play()

func toInitialPosition():
	if initialCharPosition == null:
		return
	elif initialCharPosition != null && selectedCharacter == null:
		position = initialCharPosition
	

func moveToTarget():
	if inRangeEnemies.empty():
		print("inRange empty")
		return
	print(inRangeEnemies)
	#change to alternate targets
	var newPosition = inRangeEnemies[0].getPosition()
	position = newPosition

## signals


func handleAttack():
	var tilePosition = Grid.world_to_map(position)
	var damage = selectedCharacter.damage
	var target = inRangeEnemies.pop_front()
	target.receiveDamage(damage)
	
func select_valid():
	return selectedCharacter == null;
	
#func _on_Enemy_withinRange(id):
#	if $States.current_stateName != "SelectTarget":
#		return
#	var enemy = instance_from_id(id)
#	inRangeEnemies.append(enemy)

func _on_Cursor_area_entered(area):
	if area.is_in_group("Enemies"):
		return
	if $States.current_stateName != "hovering":
		return
	hoveredCharacter = area;
	colorRangeTiles()

func _on_Cursor_area_exited(area):
	hoveredCharacter = null
	if $States.current_stateName != "selected":
		rangeTiles.clear()


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animationComplete")

func _on_Hovering_updateInitialPos():
	initialCharPosition = position

func _on_Selected_updateInitialPos():
	position = initialCharPosition
	initialCharPosition = null

func _on_Hovering_moved():
	var terrainType = obstacleTiles.getObstacleName(position)
	var cord = Grid.world_to_map(position)
	var terrainCost = obstacleTiles.getMovementCost(cord)
	setTerrainLabel("Terrain: " + terrainType + "\n" + "Move: -" + str(terrainCost))


func _on_Selections_actionSelected(selection):
	match selection:
		"Attack":
			print("oww")
		"Wait":
			return


func _on_Enemy_withinRange(id):
#	if $States.current_stateName != "SelectTarget":
#		return
	var enemy = instance_from_id(id)
	inRangeEnemies.append(enemy)


func _on_SelectTarget_attack():
	inRangeEnemies[0].receiveDamage(100)
