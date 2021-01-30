extends "../State.gd"
func _ready():
	pass

var target_position = null
signal animationFinished
signal moved

func _process(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return
	target_position = owner.Grid.requestMovePosition(self, input_direction)
	if target_position:
		owner.playMoveSFX()
		move_to(target_position)
	else:
		print("Error invalid move")

func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		)


func move_to(target_position):
	set_process(false)
	owner.get_node("AnimationPlayer").play("Walk")
	var move_direction = (target_position - owner.position).normalized()
	owner.get_node("Tween").interpolate_property(owner, "position", owner.position, target_position, 1)
	owner.get_node("Tween").start()
	yield(get_tree().create_timer(0.2), "timeout")
	emit_signal("moved")
	set_process(true)
