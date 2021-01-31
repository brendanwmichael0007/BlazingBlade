extends "State.gd"

signal toggleItemList

func enter():
	emit_signal("toggleItemList")

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	owner.selections.handle_input(event)

func update(delta):
	return

func _on_animation_finished(anim_name):
	return


func _on_Selections_actionSelected(selection):
		if selection == "Attack":
			emit_signal("finished","selectTarget")
			return
		emit_signal("finished","hovering")
