extends "movement.gd"

signal updateInitialPos

func enter():
	owner.toInitialPosition()
	set_process(true)

func handle_input(event):
	if Input.is_action_just_pressed("A"):
		if owner.hoveredCharacter == null:
			return
		owner.selectedCharacter = owner.hoveredCharacter
		owner.playSelectSFX()
		set_process(false)
		emit_signal("updateInitialPos")
		emit_signal("finished","selected")
	# x shows unit info etc

