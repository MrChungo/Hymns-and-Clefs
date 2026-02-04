extends Node2D

const ENEMY_SCENE_PATH := "uid://448b5kjxjtf5" #res://Scenes/enemies/enemy.tscn
const ENEMY_SCENE :=  preload(ENEMY_SCENE_PATH)

var difficulty :int
var round :int
var is_player_turn : bool
#enemy spawning
var enemy_quantity :int
var max_possible_enemies :int
var min_possible_enemies :int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#sets up variables for game
	is_player_turn = true
	round = 0
	max_possible_enemies = difficulty + 2
	min_possible_enemies = difficulty
	enemy_quantity = randi_range(min_possible_enemies,max_possible_enemies)
	
	#spawns enemies
	for n in range(enemy_quantity):
		var new_enemy = ENEMY_SCENE.instantiate()
		$"../EnemyManager".add_child(new_enemy)
		#new_enemy.name = card_drawn.card_name
		var texture = load("res://Resources/Enemy/enemy_recorder.tres")
		new_enemy.update_enemy_stats(texture)
	
func player_turn():
	pass
	
func enemy_turn():
	pass
