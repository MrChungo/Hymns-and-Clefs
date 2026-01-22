extends Node2D

@export var stats : card_resource

signal card_hovered
signal card_hovered_off

var position_in_hand
var deck_nodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_nodePath = get_node(^"/root/Battle/Deck")

	self.position.x = deck_nodePath.position.x
	self.position.y = deck_nodePath.position.y
	#get_node("CardImage").texture = stats.texture #I AM UP TO SMTH BUT IDK WHAT AAAAAAAA
	
	#all cards must be a child of CardManager or this will error
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("card_hovered",self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("card_hovered_off",self)
