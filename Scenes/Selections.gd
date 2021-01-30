extends ItemList

var index = 0
signal actionSelected
var selections = {0: "Attack", 1: "Wait"}
var selection

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	set_visible(false)


func handle_input(event):
	if event.is_action_released("ui_up") && index != 0:
		select(index, false)
		index -= 1
		select(index, true)
	if event.is_action_released("ui_down") && index < 1:
		select(index, false)
		index += 1
		select(index, true)
	if event.is_action_pressed("A") && is_anything_selected() && !event.is_echo():
		selection = selections[index]
		emit_signal("actionSelected",selection)
		index = 0
		unselect_all()
		set_process_input(false)
		set_visible(false)


func _on_SelectionDisplay_toggleItemList():
	print("on selection display")
	set_visible(true)
	set_process(true)
	select(index,true)
