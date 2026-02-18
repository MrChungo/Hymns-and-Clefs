extends Node2D

'''
IMPORTANT

await <---------------
'''
const PLAYER_SCENE = preload("uid://bys0uidt8s34i")#"res://Scenes/player/player.tscn"
#need to reference to actual player node plzplzplzpzlpzl
const ENEMY_SCENE :=  preload("uid://448b5kjxjtf5") #res://Scenes/enemies/enemy.tscn

var global_rarities = load("uid://dxut7bry6abc") #RANDOM_REFERENCE.get_weighted_rarity()
var test_save = load("uid://chmnudsaqsjho") #"res://Resources/Save States/Test_Battle_save.tres"

var save: save_resource

var difficulty : int
var battle_round :int
var is_player_turn : bool
var waiting_for_action: bool

#player spawning and stuffs
var player: Node2D

var card_being_used: Node2D

#enemy spawning
var enemy_quantity :int
var max_possible_enemies :int
var min_possible_enemies :int
var enemies: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#sets up variables for game
	load_from_save(test_save)
	is_player_turn = true
	
	#ENEMY STUFF!!!!!!!!!!!!!!
	max_possible_enemies = difficulty + 2
	min_possible_enemies = difficulty
	enemy_quantity = randi_range(min_possible_enemies,max_possible_enemies)
	
	#spawns enemies & player
	spawn_enemies(enemy_quantity)
	spawn_player()



func load_from_save(loaded_save):
	save = loaded_save
	difficulty = save.world_difficulty
	battle_round = save.last_battle_round 

#player functions
func spawn_player():
	player = PLAYER_SCENE.instantiate()
	$"..".add_child.call_deferred(player)
	player.name = "player"
	player.load_player_stats(save)


func player_turn():
	#checks if card is in slot
	if $"../UsedCardSlot".card_in_slot:
		card_being_used = $"../UsedCardSlot".card_in_slot
		
		var target = select_target()
		use_card(target, card_being_used)

func select_target():
	pass

func use_card(target, card):
	if card.attack_points >= 0:
		attack(target, card.attack_points)
	pass

#enemy functions
func spawn_enemies(_enemy_quantity):
	#spawns enemies
	print("spawned ", _enemy_quantity, " enemies")
	for n in range(_enemy_quantity):
		var new_enemy = ENEMY_SCENE.instantiate()
		$"../EnemyManager".add_child(new_enemy)
		new_enemy.name = "enemy"
		var stats = load("res://Resources/Enemy/AAAAAAAAAAAAAAAA.tres") #temp stats!!!!!!!!!!!!!!!
		new_enemy.update_enemy_stats(stats)
		enemies.append(new_enemy)

func enemy_turn():
	#loops through enemies
	for enemy in enemies:
		var chosen_action = enemy_choose_action(enemy)
		enemy_action(enemy,chosen_action)
		
	is_player_turn = true

func enemy_choose_action(_enemy):
	var enemy_action_type = _enemy.enemy_action_type
	var action = "doNothing"
	if enemy_action_type == 0: #balanced
		action = $"../Random".get_weighted_rarity(global_rarities.enemy_balanced_attack_rarity)
	elif enemy_action_type == 1: #attacker
		action = $"../Random".get_weighted_rarity(global_rarities.enemy_attacker_attack_rarity)
	elif enemy_action_type == 2: #defender
		action = $"../Random".get_weighted_rarity(global_rarities.enemy_defender_attack_rarity)
	return action

func enemy_action(_enemy, action):
	if action != "doNothing":
		if action == "attack":
			attack(player,_enemy.attack)
		elif action == "defend":
			add_shield(_enemy, _enemy.shield_attack)

#general functions (used for both enemies and players)
func attack(target, damage):
	target.hp -= damage
	
func add_shield(target, shield_added):
	target.shield += shield_added

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_player_turn:
		player_turn()
	else:
		enemy_turn()
		print(player.hp)
			
		
