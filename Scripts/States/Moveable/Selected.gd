extends "movement.gd"

signal updateInitialPos

func enter():
	set_process(true)

func exit():
		owner.playSelectSFX()
		owner.moveCharacter()
		owner.rangeTiles.clear()

func handle_input(event):
	if Input.is_action_just_pressed("A"):
		if !owner.validMove():
			return
		exit()
		set_process(false)
		emit_signal("finished","selectionDisplay")
	if Input.is_action_just_pressed("B"):
		set_process(false)
		emit_signal("updateInitialPos")
		emit_signal("finished","hovering")
		

func update(delta):
	return

func _on_animation_finished(anim_name):
	return
