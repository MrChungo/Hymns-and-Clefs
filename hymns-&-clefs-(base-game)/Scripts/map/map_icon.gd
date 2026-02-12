extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_icon_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_area_2d_mouse_entered() -> void:
	emit_signal("icon_hovered",self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("icon_hovered_off",self)
