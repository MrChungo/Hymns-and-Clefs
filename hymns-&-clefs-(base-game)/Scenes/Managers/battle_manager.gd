extends Node2D

'''
IMPORTANT

await <---------------
'''
const PLAYER_SCENE = preload("uid://bys0uidt8s34i") #"res://Scenes/player/player.tscn"
#need to reference to actual player node plzplzplzpzlpzl
const ENEMY_SCENE :=  preload("uid://448b5kjxjtf5") #res://Scenes/enemies/enemy.tscn
const RANDOM_REFERENCE := preload("uid://bvdiog5mff0jt") #"res://Scenes/Misc/random.tscn"
#need to reference to random node for it to work

var global_rarities = load("uid://dxut7bry6abc") #RANDOM_REFERENCE.get_weighted_rarity()
var test_save = load("uid://chmnudsaqsjho") #"res://Resources/Save States/Test_Battle_save.tres"

var save: save_resource

var difficulty : int
var battle_round :int
var is_player_turn : bool
var waiting_for_action: bool

#enemy spawning
var enemy_quantity :int
var max_possible_enemies :int
var min_possible_enemies :int

var enemies: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(PLAYER_SCENE.health)
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
		var stats = load("res://Resources/Enemy/AAAAAAAAAAAAAAAA.tres") #temp stats
		new_enemy.update_enemy_stats(stats)
		enemies.append(new_enemy)
		
	print(enemies)
	
	
func load_from_save(loaded_save):
	save = loaded_save
	difficulty = save.world_difficulty
	battle_round = save.last_battle_round 
	
func player_turn():
	pass

#enemy functions
func enemy_turn():
	#loops through enemies
	for enemy in enemies:
		var chosen_action = enemy_choose_action(enemy)
		enemy_action(enemy,chosen_action)

func enemy_choose_action(_enemy):
	var action_type = _enemy.enemy_action_type
	var action = "doNothing"
	if action_type == 0: #balanced
		action = RANDOM_REFERENCE.get_weighted_rarity(global_rarities.enemy_balanced_attack_rarity)
	elif action_type == 1: #attacker
		action = RANDOM_REFERENCE.get_weighted_rarity(global_rarities.enemy_attacker_attack_rarity)
	elif action_type == 2: #defender
		action = RANDOM_REFERENCE.get_weighted_rarity(global_rarities.enemy_defender_attack_rarity)
	return action

func enemy_action(_enemy, action):
	if action != "doNothing":
		if action == "attack":
			attack(PLAYER_SCENE,_enemy.base_enemy_attack)
		elif action == "defend":
			pass

func attack(target, damage):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
