extends Node2D
class_name GlobalsClass ##This class is used to save values that will need to be used globally.

@onready var center_screen_y
@onready var center_screen_x
@onready var card_scale_factor

func _ready() -> void:
	update_globals()
	#print("screen_width: ",center_screen_x)
	#print("screen_height: ",center_screen_y)

## This method updates the global values depending on the screen size.
func update_globals() -> void:
	var center = get_viewport().size / 2.0
	center_screen_x = center.x
	center_screen_y = center.y
	card_scale_factor = round(Globals.center_screen_x / 250)
