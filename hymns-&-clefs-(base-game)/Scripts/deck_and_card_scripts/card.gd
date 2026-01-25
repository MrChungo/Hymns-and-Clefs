extends Node2D

@export var stats : card_resource

signal card_hovered
signal card_hovered_off

var position_in_hand
var deck_nodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats = load("res://Resources/Card/Common_Rarity/common_wooden_shield.tres")
	deck_nodePath = get_node(^"/root/Battle/Deck")

	self.position.x = deck_nodePath.position.x
	self.position.y = deck_nodePath.position.y
	$CardImage.texture = stats.texture
	
	#all cards must be a child of CardManager or this will error
	get_parent().connect_card_signals(self)

func _update_card_stats(resource):
	var stats = resource
	$CardImage.texture = stats.texture
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("card_hovered",self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("card_hovered_off",self)
