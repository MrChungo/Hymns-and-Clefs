extends TextureButton
class_name TexturedButton

var button_scale:float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_pivot()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


## This method sets the button's pivot to half it's size.
func set_pivot() -> void:
	pivot_offset = size/2


func _on_mouse_entered() -> void:
	if !disabled:
		create_tween().tween_property(self, "scale", Vector2(button_scale*1.15,button_scale*1.15),0.1)
func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "scale", Vector2(button_scale,button_scale),0.1)
