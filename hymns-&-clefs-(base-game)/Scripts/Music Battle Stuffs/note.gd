extends Node2D

signal note_hovered
signal note_hovered_off

var note: String
var position_in_hand
var measure:int

func _ready() -> void:
	get_parent().connect_note_signals(self)



func _on_mouse_clickeable_mouse_entered() -> void:
	emit_signal("note_hovered",self)


func _on_mouse_clickeable_mouse_exited() -> void:
	emit_signal("note_hovered_off",self)
