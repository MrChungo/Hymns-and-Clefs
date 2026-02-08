extends Node2D

const ENEMY_SCENE_PATH := "uid://448b5kjxjtf5" #res://Scenes/enemies/enemy.tscn
const ENEMY_SCENE :=  preload(ENEMY_SCENE_PATH)

var test_save = load("uid://chmnudsaqsjho") #"res://Resources/Save States/Test_Battle_save.tres"

var save: save_resource

var difficulty : int
var battle_round :int
var is_player_turn : bool
#enemy spawning
var enemy_quantity :int
var max_possible_enemies :int
var min_possible_enemies :int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#sets up variables for game
	load_from_save(test_save)
	is_player_turn = true
	
	max_possible_enemies = difficulty + 2
	min_possible_enemies = difficulty
	enemy_quantity = randi_range(min_possible_enemies,max_possible_enemies)
	
	#spawns enemies
	print("spawned ", enemy_quantity, " enemies")
	for n in range(enemy_quantity):
		var new_enemy = ENEMY_SCENE.instantiate()
		$"../EnemyManager".add_child(new_enemy)
		new_enemy.name = "enemy"
		var stats = load("res://Resources/Enemy/AAAAAAAAAAAAAAAA.tres")
		new_enemy.update_enemy_stats(stats)
	
func load_from_save(loaded_save):
	save = loaded_save
	difficulty = save.world_difficulty
	battle_round = save.last_battle_round 
	
func player_turn():
	pass
	
func enemy_turn():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
