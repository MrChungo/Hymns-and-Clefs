extends Resource
class_name save_resource

#general stuff
@export var world_difficulty: int

#map stuff


#player stuffs
@export var current_player_hp: int
@export var max_player_hp: int
@export var deck: Array[card_resource]

#battle stuff
@export var last_battle_round: int
@export var enemies: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
