extends Control

var cursor = load("res://Sprites/InvertCursor.png")

func _ready():
	Input.set_custom_mouse_cursor(cursor)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
