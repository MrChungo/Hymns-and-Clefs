extends Node2D

@export var stats : card_resource

#var card_texture = load('stats.texture')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$CardImage.texture = card_texture # WHY DOES THIS NOT WORK!!!!!!!! AAAAAAAAAAAAAAAAAAAAAAAAAA
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	print("entered")


func _on_area_2d_mouse_exited() -> void:
	print("exited")
