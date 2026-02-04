extends Node2D

@export var stats : enemy_resource

var enemy_hp :int
var enemy_attack :int
var enemy_difficulty := 1 #could be in/changed in world

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats = load("uid://c4wyd05w5s88l") #"res://Resources/Enemy/_debug_enemy.tres"
	self.scale = Vector2(2,2)
	self.position.x = 200
	self.position.y = 100
	
	enemy_hp = stats.base_enemy_hp * enemy_difficulty
	enemy_attack = stats.base_enemy_attack * enemy_difficulty
	$EnemyTexture.texture = stats.texture
	$EnemyTexture.hframes = stats.texture_frames
	
func update_enemy_stats(new_resource):
	stats = new_resource
	enemy_hp = stats.base_enemy_hp * enemy_difficulty
	enemy_attack = stats.base_enemy_attack * enemy_difficulty
	$EnemyTexture.texture = stats.texture
	$EnemyTexture.hframes = stats.texture_frames
	
