extends Node2D

@export var stats : card_resource

signal card_hovered
signal card_hovered_off

#var card_texture = load('stats.texture')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$CardImage.texture = card_texture # WHY DOES THIS NOT WORK!!!!!!!! AAAAAAAAAAAAAAAAAAAAAAAAAA
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("card_hovered",self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("card_hovered_off",self)
