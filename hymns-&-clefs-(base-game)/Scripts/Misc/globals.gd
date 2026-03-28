extends Node2D

@onready var center_screen_y =  get_viewport().size.y / 2
@onready var center_screen_x = get_viewport().size.x / 2

func update_globals():
	center_screen_y =  get_viewport().size.y / 2
	center_screen_x = get_viewport().size.x / 2
