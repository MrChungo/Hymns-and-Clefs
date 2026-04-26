extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_pivot()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func set_pivot() -> void:
	pivot_offset = size/2


func _on_mouse_entered() -> void:
	create_tween().tween_property(self, "scale", Vector2(1.1,1.1),0.1)
func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "scale", Vector2(1,1),0.1)
