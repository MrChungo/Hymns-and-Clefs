extends Node2D

signal icon_hovered
signal icon_hovered_off
var enterable:bool
var icon_type: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_icon_signals(self)

	
func _on_area_2d_mouse_entered() -> void:
	emit_signal("icon_hovered",self)




func _on_area_2d_mouse_exited() -> void:
	emit_signal("icon_hovered_off",self)
