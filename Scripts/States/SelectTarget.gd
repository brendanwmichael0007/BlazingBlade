extends "State.gd"

signal attack

func enter():
	owner.moveToTarget()
	return

func exit():
	return

func handle_input(event):
	if Input.is_action_just_pressed("A"):
		emit_signal("attack")
		emit_signal("finished","hovering")

func _on_animation_finished(anim_name):
	return
