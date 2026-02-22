extends Node2D
class_name enemy_class


@export var stats : enemy_resource

var hp :int
var attack :int
var shield: int
var shield_attack: int
var enemy_difficulty := 1 #could be in/changed in world
var enemy_action_type: int #0 = balanced, 1 = attacker, 2 = defender

var card_in_slot: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale = Vector2(3,3)

func update_enemy_stats(loaded_stats):
	stats = loaded_stats
	hp = stats.base_enemy_hp * enemy_difficulty
	attack = stats.base_enemy_attack * enemy_difficulty
	shield = stats.base_starting_shield * enemy_difficulty
	shield_attack = stats.base_enemy_shield_attack * enemy_difficulty
	enemy_action_type = stats.enemy_action_type
	$EnemyTexture.hframes = stats.texture_frames
	$EnemyTexture.texture = stats.texture
	
func death():
	self.queue_free()
	
