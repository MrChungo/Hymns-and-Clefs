extends Node2D

const PLAYER_SCENE = preload("uid://bys0uidt8s34i")#"res://Scenes/player/player.tscn"
const ENEMY_SCENE :=  preload("uid://448b5kjxjtf5") #res://Scenes/enemies/enemy.tscn
const MAX_ENEMIES_PER_ROW:= 4
const VERTICAL_ENEMY_SPACING:= 100
const HORIZONTAL_ENEMY_SPACING := 100

signal card_used(enemy)

var global_rarities = load("uid://dxut7bry6abc") #RANDOM_REFERENCE.get_weighted_rarity()
var test_save = load("uid://chmnudsaqsjho") #"res://Resources/Save States/Test_Battle_save.tres"

var save: save_resource

var difficulty : int
var battle_round :int
var is_player_turn : bool
var waiting_for_action: bool
var battle: bool

#player spawning and stuffs
var player: Node2D

var card_being_used: Node2D

#enemy spawning
var enemy_quantity :int
var max_possible_enemies :int
var min_possible_enemies :int
var enemies: Array
var screen_width: int
var screen_height: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save = load("res://Resources/Save States/Test_Battle_save.tres")
	
	
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y

	battle = true
	#sets up variables for game
	load_from_save(test_save)
	is_player_turn = true
	
	#ENEMY STUFF!!!!!!!!!!!!!!
	max_possible_enemies = difficulty + 2
	min_possible_enemies = difficulty
	#enemy_quantity = randi_range(min_possible_enemies,max_possible_enemies)
	enemy_quantity = 3
	#spawns enemies & player
	spawn_enemies(enemy_quantity)
	spawn_player()
	

	battle_loop()



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
	print(player.hp)
	@warning_ignore("integer_division")
	player.global_position.y = (screen_height/2)
	@warning_ignore("integer_division")
	player.global_position.x = (screen_width/4)


func player_turn():
	draw_cards_to_hand()
	
	#checks if card is in slot
	await %card_manager.card_used_on_enemy
	
	var target = select_target()
	await use_card(target, target.card_in_slot)
	
	empty_hand()
	
	
	is_player_turn = false
	
func player_death(target):
	target.death()

#card logic
func select_target():
	for n in enemies:
		if n.card_in_slot:
			return n

func use_card(target, card):
	if card.stats.attack_points >= 0:
		attack(target, card.stats.attack_points)
	
		
	emit_signal("card_used", target)

func draw_cards_to_hand():
	var deck_ref = %Deck
	for n in range(3): #AAAAAAAAAAAAAAA
		print("a")
		deck_ref.draw_card()

func empty_hand():
	var hand_ref = %Hand
	var deck_ref = %Deck
	
	for n in hand_ref.player_hand:
		deck_ref.send_card_to_discard(n)
	hand_ref.player_hand.clear()

	

#enemy functions
func spawn_enemies(_enemy_quantity):
	print("spawned ", _enemy_quantity, " enemies")
	for n in range(_enemy_quantity):
		var new_enemy = ENEMY_SCENE.instantiate()
		$"../EnemyManager".add_child(new_enemy)
		#$"..".add_child(new_enemy)
		new_enemy.name = "enemy"
		var stats = load("res://Resources/Enemy/AAAAAAAAAAAAAAAA.tres") #temp stats!!!!!!!!!!!!!!!
		new_enemy.update_enemy_stats(stats)
		enemies.append(new_enemy)
	
	update_enemy_positions()
	

func update_enemy_positions():
	for n in range(len(enemies)):
		@warning_ignore("integer_division")
		var row = int(n / 4)
		var column = n % 4
		@warning_ignore("integer_division")
		enemies[n].global_position.y = (screen_height/2) - (row * VERTICAL_ENEMY_SPACING)
		@warning_ignore("integer_division")
		enemies[n].global_position.x = (screen_width/2) + (column * HORIZONTAL_ENEMY_SPACING) + 200 # WORK OUT THIS LATER





func enemy_turn():
	#loops through enemies
	
	for _enemy in enemies:
		var chosen_action = enemy_choose_action(_enemy)
		enemy_action(_enemy,chosen_action)
		
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
			
func enemy_death(target):
	enemies.erase(target)
	await target.death()

#general functions (used for both enemies and players)
func attack(target, damage):
	if target.shield > 0:
		target.shield -= damage
	else:
		target.shield = 0
		target.hp -= damage
	
	if target.hp <= 0:
		if target is enemy_class:
			enemy_death(target)
		elif target is player_class:
			player_death(target)
	
func add_shield(target, shield_added):
	target.shield += shield_added


func battle_loop():
	while battle:
		if is_player_turn:
			await player_turn()
		else:
			await enemy_turn()
			print("player hp", player.hp)
			
		
