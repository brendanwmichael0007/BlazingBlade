extends ItemList

var index = 0
signal actionSelected
var selections = {0: "Attack", 1: "Wait"}
var selection


func _ready():
	set_process_unhandled_input(false)
	
func _on_Cursor_displayActions():
	set_visible(true)
	select(index,true)
	set_process_unhandled_input(true)
	

func _unhandled_input(event):
	if event.is_action_released("ui_up") && index != 0:
		select(index, false)
		index -= 1
		select(index, true)
		print(selections[index])
	if event.is_action_released("ui_down") && index < 1:
		select(index, false)
		index += 1
		select(index, true)
		print(selections[index])
	if event.is_action_pressed("A") && is_anything_selected() && !event.is_echo():
		$AudioStreamPlayer.play()
		selection = selections[index]
		print(selections[index])
		emit_signal("actionSelected",selection)
		index = 0
		unselect_all()
		set_process_unhandled_input(false)
		set_visible(false)

