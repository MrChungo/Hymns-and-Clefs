extends Node2D

# THIS FILE MUST BE AT THE BOTTOM OF THE TREE FOR EVERYTHING TO WORK

const BATTLE_CHORD_SYSTEM_SCENE = preload("uid://b6oxxvrroq6ke")#"res://Scenes/Music Battle System Stuffs/Battle_Chord_system.tscn"
const PLAYER_SCENE = preload("uid://bys0uidt8s34i")#"res://Scenes/player/player.tscn"
const ENEMY_SCENE :=  preload("uid://448b5kjxjtf5") #res://Scenes/enemies/enemy.tscn
const MAX_ENEMIES_PER_ROW:= 4
const VERTICAL_ENEMY_SPACING:= 125
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
var hand_size: int
var card_being_used: Node2D

#battle runtime stuff
var battle_chord_system

#enemy spawning
var enemy_quantity :int
var max_possible_enemies :int
var min_possible_enemies :int
var enemies: Array
var screen_width: int
var screen_height: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	
	battle_setup()


func battle_setup():
	is_player_turn = true
	
	#spawns player
	spawn_player()
	player.update_label()
	
	#loads data
	await load_from_save()
	
	

	#ENEMY STUFF!!!!!!!!!!!!!!
	max_possible_enemies = difficulty + 2
	min_possible_enemies = difficulty
	enemy_quantity = randi_range(min_possible_enemies,max_possible_enemies)
	#spawns enemies & player
	spawn_enemies(enemy_quantity)
	
	if (len(SaveManager.save_file_data.map_icons) - 1) == SaveManager.save_file_data.current_icon:
		spawn_boss_enemy()
	
	update_enemy_labels()
	
	battle = true
	battle_round = 0
	battle_loop()


func load_from_save():
	#SaveManager._new_save() #used for debug (it resetst the save file) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	await SaveManager._load()
	await player.load_player_stats()
	#player.hp = 6666666666666
	await %Deck.load_from_save()
	difficulty = SaveManager.save_file_data.world_difficulty
	hand_size = SaveManager.save_file_data.hand_size

func save_to_savefile():
	await player.save_player_stats()
	await %Deck.save_to_savefile()
	await SaveManager._save()

#player functions
func spawn_player():
	player = PLAYER_SCENE.instantiate()
	$"..".add_child.call_deferred(player)
	player.name = "player"
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
	
	
	
	
	player.update_label()
	update_enemy_labels()
	is_player_turn = false
	
func player_death(target):
	battle = false
	target.death()
	SignalManager.change_scene_to_death()

#card logic
func select_target():
	for n in enemies:
		if n.card_in_slot:
			return n

func use_card(target, card):
	empty_hand()
	
	await load_battle_chord_system(card)
	
	if battle_chord_system.last_chord_check:
		if card.stats.attack_points > 0:
			attack(target, card.stats.attack_points)
		if card.stats.shield_points > 0:
			add_shield(player, card.stats.shield_points)
		if card.stats.health_gain > 0:
			heal(player, card.stats.health_gain)
	
	unload_battle_chord_system()
	emit_signal("card_used", target)

func draw_cards_to_hand():
	var deck_ref = %Deck
	for n in range(hand_size):
		deck_ref.draw_card()
	if len(%Hand.player_hand) < hand_size:
		for n in range(hand_size - len(%Hand.player_hand)):
			deck_ref.draw_card()

func empty_hand():
	var hand_ref = %Hand
	var deck_ref = %Deck
	
	for n in hand_ref.player_hand:
		deck_ref.send_card_to_discard(n)
	hand_ref.player_hand.clear()



func load_battle_chord_system(card):
	var measures
	if card.stats.rarity == 1:
		measures = 1
	elif card.stats.rarity == 2:
		measures = 2
	elif card.stats.rarity == 3:
		measures = 4
	else:
		measures = 1
	battle_chord_system = BATTLE_CHORD_SYSTEM_SCENE.instantiate()
	battle_chord_system.name = "BattleChordSystem"
	$"..".add_child(battle_chord_system)
	await get_tree().process_frame
	battle_chord_system.load_battle_chord_system(measures)
	%InputManager.refresh_conections()
	await battle_chord_system.chord_checked

func unload_battle_chord_system():
	battle_chord_system.queue_free()
	battle_chord_system = null



#enemy functions
func spawn_enemies(_enemy_quantity):
	#print("spawned ", _enemy_quantity, " enemies")
	for n in range(_enemy_quantity):
		var new_enemy = ENEMY_SCENE.instantiate()
		$"../EnemyManager".add_child(new_enemy)
		new_enemy.name = "enemy"
		var stats = load(Random.get_random_enemy_resource(false))
		
		await new_enemy.update_enemy_stats(stats)
		new_enemy.enemy_next_action = enemy_choose_action(new_enemy)
		enemies.append(new_enemy)
		
	
	update_enemy_positions()

func update_enemy_positions():
	for n in range(len(enemies)):
		@warning_ignore("integer_division")
		var row = int(n / 4)
		var column = n % 4
		@warning_ignore("integer_division")
		enemies[n].global_position.y = (screen_height/2) - (row * VERTICAL_ENEMY_SPACING) + VERTICAL_ENEMY_SPACING/2
		@warning_ignore("integer_division")
		enemies[n].global_position.x = (screen_width/2) + (column * HORIZONTAL_ENEMY_SPACING) + 200 # WORK OUT THIS LATER

func spawn_boss_enemy():
	var new_enemy = ENEMY_SCENE.instantiate()
	$"../EnemyManager".add_child(new_enemy)
	new_enemy.name = "BOSS_ENEMY"
	var stats = load(Random.get_random_enemy_resource(true))
	
	await new_enemy.update_enemy_stats(stats)
	new_enemy.enemy_next_action = enemy_choose_action(new_enemy)
	enemies.append(new_enemy)
	
	update_enemy_positions()

func update_enemy_labels():
	for n in enemies:
		n.update_label()

func enemy_turn():
	#loops through enemies
	
	for _enemy in enemies:
		enemy_action(_enemy,_enemy.enemy_next_action)
		_enemy.enemy_next_action = enemy_choose_action(_enemy)
	
	player.update_label()
	update_enemy_labels()
	is_player_turn = true

func enemy_choose_action(_enemy):
	var enemy_action_type = _enemy.enemy_action_type
	var action = "doNothing"
	if enemy_action_type == 0: #balanced
		action = Random.get_weighted_rarity(global_rarities.enemy_balanced_attack_rarity)
	elif enemy_action_type == 1: #attacker
		action = Random.get_weighted_rarity(global_rarities.enemy_attacker_attack_rarity)
	elif enemy_action_type == 2: #defender
		action = Random.get_weighted_rarity(global_rarities.enemy_defender_attack_rarity)
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
		if target.shield < 0:
			target.shield = 0
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

func heal(target, health):
	target.hp += health
	if target is player_class:
		if target.hp > target.max_hp:
			target.hp = target.max_hp
	

func battle_loop():
	while battle:
		if enemies.size() > 0:
			if is_player_turn:
				await player_turn()
			else:
				await enemy_turn()
				#print("player hp", player.hp)
		else:
			battle_ends()

func battle_ends():
	SaveManager.save_file_data.current_icon += 1
	await save_to_savefile()
	battle = false
	if SaveManager.save_file_data.current_icon == 5 and SaveManager.save_file_data.world_difficulty == 0:
		SignalManager.change_scene_to_win()
	else:
		SignalManager.change_scene_to_rewards()



	
