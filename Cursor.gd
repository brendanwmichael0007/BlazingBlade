extends Node2D

onready var Grid = get_parent()
onready var sprite: AnimatedSprite = $AnimatedSprite
onready var blueTiles = $"../RangeLayer"
onready var redTiles = $"../AttackLayer"

enum states {hovering, selected, move, displayActions, actionSelected, acting, view, ret}
var state = states.hovering

signal displayActions
var initialCharPosition
var inRangeEnemies = []
var hoveredCharacter = null
var selectedCharacter = null
var selection = null
var target_position = 0

class tileDictionary:
	var tileColors = {}
	
func _ready():
	pass

func _unhandled_input(event):
	#to do: fix input issues with Garrett
	if Input.is_action_just_pressed("A"):
		match state:
			states.hovering:
				if hoveredCharacter == null:
					return
				print("selected state")
				state = states.selected
				handleSelected()
				return
			states.selected:
				print("display state")
				state = states.displayActions
				moveCharacter()
				handleDisplay()
				return
			states.displayActions:
				print("actionSelected state")
				state = states.actionSelected
				handleActionSelected()
				return
			states.acting:
				state = state.hover
				#handleHover
				return
	if Input.is_action_just_pressed("B"):
		match state:
			states.selected:
				print("hover state")
				handleSelectedBack()
				state = states.hovering
				handleHover()
			states.displayActions:
				print("hover state")
				handleDisplayBack()
				state = states.hovering
#				handleHover()
			states.view:
				state = states.hovering
	if Input.is_action_just_pressed("X"):
		match state:
			states.hovering:
				state = states.view
	if Input.is_action_just_pressed("Y"):
		#speed up cursor
		print("weeee")

func _process(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return
	target_position = Grid.requestMovePosition(self, input_direction)
	if target_position:
		$MoveSFX.play()
		move_to(target_position)
	else:
		print("Error invalid move")

func handleHover():
	self.position = selectedCharacter.position
	selectedCharacter = null

func handleSelected():
	selectedCharacter = hoveredCharacter;
	initialCharPosition = selectedCharacter.position
	$SelectSFX.play()
	var playerMovement = selectedCharacter.movement
	var moveDistance = selectedCharacter.movement + selectedCharacter.attackRange
	var tilePosition = Grid.world_to_map(position)
	var tileColors = tileDictionary.new()
	
	floodFill(tileColors, tilePosition, moveDistance)
	blueTiles.visible = true
	redTiles.visible = true
	for key in tileColors.tileColors:
		var val = tileColors.tileColors[key]
		if val >= moveDistance - playerMovement:
			blueTiles.set_cellv(key,0)
		else:
			redTiles.set_cellv(key,0)

func handleSelectedBack():
	clearTiles()
	$SelectSFX.play()

func handleDisplay():
	emit_signal("displayActions")
	set_visible(false)
	set_process_unhandled_input(false)

func handleDisplayBack():
	set_visible(true)
	set_process(true)
	handleSelectedBack()
	selectedCharacter.position = initialCharPosition
	handleHover()

func handleActionSelected():
	print("selection ", selection)
	match selection:
		"Attack":
			print("attackies")

func floodFill(tileDictionary,tilePosition, movement):
	if tileDictionary.tileColors.has(tilePosition):
		var currentValue = tileDictionary.tileColors[tilePosition]
		tileDictionary.tileColors[tilePosition] = max(currentValue, movement)
	else:
		tileDictionary.tileColors[tilePosition] = movement
	if(movement > 0):
		floodFill(tileDictionary, tilePosition + Vector2(1,0), movement - 1)
		floodFill(tileDictionary, tilePosition - Vector2(1,0), movement - 1)
		floodFill(tileDictionary, tilePosition + Vector2(0,1), movement - 1)
		floodFill(tileDictionary, tilePosition - Vector2(0,1), movement - 1)
	return

func moveCharacter():
	if selectedCharacter != null:
		var pos = target_position
		var tilePos = blueTiles.world_to_map(pos)
		if blueTiles.get_cellv(tilePos) == 0:
			selectedCharacter.move_to(position)
			$SelectSFX.play()
			blueTiles.visible = false
			redTiles.visible = false
		else:
			$InvalidSFX.play()


func get_input_direction():
	if !is_processing_unhandled_input():
		return
	else:
		return Vector2(
			int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
			int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		)

func clearTiles():
	redTiles.clear()
	blueTiles.clear()

#to do: fix outside of bounds movement
func move_to(target_position):
	set_process(false)
	$AnimationPlayer.play("Walk")
	var move_direction = (target_position - position).normalized()
	$Tween.interpolate_property(self, "position", position, target_position, 1)
	$Tween.start()
	yield($AnimationPlayer, "animation_finished")
	set_process(true)

func getEnemy():
	pass

## signals
func _on_ItemList_actionSelected(selected):
	selection = selected

func handleAttack():
	var tilePosition = Grid.world_to_map(position)
	var damage = selectedCharacter.damage
	var target = inRangeEnemies.pop_front()
	target.receiveDamage(damage)
	
func select_valid():
	return selectedCharacter == null;

func _on_Cursor_area_entered(area):
	hoveredCharacter = area;

func _on_Cursor_area_exited(area):
	hoveredCharacter = null

func _on_Enemy_withinRange(id):
	var enemy = instance_from_id(id)
	inRangeEnemies.append(enemy)
	
func update_look_direction(direction):
	sprite.rotation = direction.angle()
