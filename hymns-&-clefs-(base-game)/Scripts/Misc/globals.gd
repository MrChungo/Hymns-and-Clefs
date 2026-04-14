extends Node2D

@onready var center_screen_y
@onready var center_screen_x

func _ready() -> void:
	update_globals()
	print("screen_width: ",center_screen_x)
	print("screen_height: ",center_screen_y)

func update_globals():
	var center = get_viewport().size / 2.0
	center_screen_x = center.x
	center_screen_y = center.y
