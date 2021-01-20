extends Area2D
onready var sprite: Sprite = $Sprite

export var movement = 4
export var attackRange = 2
var hp = 100
var damage = 100

enum STATES {ALIVE,DEAD}

var state = STATES.ALIVE
var pos = position
signal animationComplete

func _ready():
	pass # Replace with function body.

func update_look_direction(direction):
	sprite.rotation = direction.angle()

func attack(amount):
	pass

func receive_damage(amount):
	hp -= amount
	if hp <= 0:
		state = STATES.DEAD
		sprite.visible(false)

func move_to(cursorPosition):
	set_process(false)
	$AnimationPlayer.play("Walk")
	$Tween.interpolate_property(self, "position", position, cursorPosition, 1)
	$Tween.start()
	yield($AnimationPlayer, "animation_finished")
	set_process(true)
	emit_signal("animationComplete")
	
func _on_Player_area_entered(area):
	
	pass # Replace with function body.

