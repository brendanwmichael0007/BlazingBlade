extends Node2D

func _ready():
	$cam.set_zoom(Vector2(1.4,1.4)) # 17 x 10


func _input(event):
	if Input.is_action_pressed("ZoomOut"):
		$cam.set_zoom(Vector2(1.2,1.2)) # 17 x 10
	if Input.is_action_just_released("ZoomIn"):
		$cam.set_zoom(Vector2(1.0,1.0)) # 14 x 8
