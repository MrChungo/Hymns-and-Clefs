extends Resource
class_name starting_deck_resource

const CARD_SCENE_PATH := "res://Scenes/card_stuffs/card.tscn"
const CARD_SCENE :=  preload(CARD_SCENE_PATH)

@export var deck_resource : Array[card_resource] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
