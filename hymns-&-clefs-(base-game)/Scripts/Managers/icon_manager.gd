extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func connect_icon_signals(icon):
	icon.connect("icon_hovered", on_hovered_over_icon)
	icon.connect("icon_hovered_off", on_hovered_off_icon)
