extends Node2D
class_name card_class

@export var stats : card_resource

signal card_hovered
signal card_hovered_off

var position_in_hand
var card_slot_card_is_in

var deck_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	#all cards must be a child of CardManager or this will error
	get_parent().connect_card_signals(self)

func move_card_to_deck():
	self.position.x = deck_reference.position.x
	self.position.y = deck_reference.position.y

func _update_card_stats(loaded_stats):
	stats = loaded_stats
	$CardImage.texture = stats.texture


func _on_area_2d_mouse_entered() -> void:
	emit_signal("card_hovered",self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("card_hovered_off",self)
