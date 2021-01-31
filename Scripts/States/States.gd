extends Node

signal state_changed(current_state)
var startState = "hovering"
var states = {}

var current_state = null
var current_stateName = "hovering"

func _ready():
	for child in get_children():
		child.connect("finished", self, "_change_state")
	states = {"hovering":$Hovering, "selected":$Selected, "selectionDisplay":$SelectionDisplay,
			"selectTarget": $SelectTarget
			}
	initialize(startState)

func initialize(start_state):
	current_state = states["hovering"]
	current_state.enter()
	print("hovering")

func _input(event):
	current_state.handle_input(event)

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

func _change_state(state_name):
	current_state.exit()
	current_state = states[state_name]
	current_stateName = state_name
	print(state_name)
	emit_signal("state_changed", current_state)
	current_state.enter()
