extends Node2D

@export var stats : enemy_resource

var enemy_hp :int
var enemy_attack :int
var enemy_difficulty := 1 #could be in/changed in world

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale = Vector2(2,2)
	self.position.x = 200
	self.position.y = 100

func update_enemy_stats(loaded_stats):
	stats = loaded_stats
	enemy_hp = stats.base_enemy_hp * enemy_difficulty
	enemy_attack = stats.base_enemy_attack * enemy_difficulty
	$EnemyTexture.hframes = stats.texture_frames
	$EnemyTexture.texture = stats.texture
