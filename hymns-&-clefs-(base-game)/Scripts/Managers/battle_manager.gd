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
	player.emit_signal("healthChanged")
	
	#loads data
	await load_from_save()
	
	

	#ENEMY STUFF!!!!!!!!!!!!!!
	max_possible_enemies = difficulty + 1
	min_possible_enemies = difficulty
	enemy_quantity = Random.get_random_int(min_possible_enemies,max_possible_enemies)
	
	print("min enemies: " + str(min_possible_enemies),"max enemies: " + str(max_possible_enemies), "enemy quant: " + str(enemy_quantity))
	#spawns enemies & player
	
	await spawn_enemies(enemy_quantity)
	
	if (len(SaveManager.save_file_data.map_icons) - 1) == SaveManager.save_file_data.current_icon:
		spawn_boss_enemy()
	
	await get_tree().process_frame
	alternate_update_enemy_positions()
	
	update_enemy_labels()
	battle = true
	battle_round = 0
	
	await get_tree().process_frame
	if SaveManager.save_file_data.deck.deck_resource.size() < 1:
		battle = false
		player_death(player)
	battle_loop()


func load_from_save():

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

	player.global_position.y = (screen_height/2.0)

	player.global_position.x = (screen_width/8.0)
	
	var player_scale_factor = Globals.card_scale_factor*2
	player.scale = Vector2(player_scale_factor,player_scale_factor)

func player_turn():
	draw_cards_to_hand()
	
	#checks if card is in slot
	await %card_manager.card_used_on_enemy
	
	var target = select_target()
	
	await use_card(target, target.card_in_slot)
	
	
	
	
	player.emit_signal("healthChanged")
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
	card.visible = false
	
	await load_battle_chord_system(card)
	battle_chord_system.visible = false
	if battle_chord_system.last_chord_check:
		if card.stats.attack_points > 0:
			await attack(target, card.stats.attack_points)
		if card.stats.shield_points > 0:
			await add_shield(player, card.stats.shield_points)
		if card.stats.health_gain > 0:
			await heal(player, card.stats.health_gain)
	
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
	print("chord checked")

func unload_battle_chord_system():
	battle_chord_system.queue_free()
	battle_chord_system = null

#enemy functions
func spawn_enemies(_enemy_quantity):
	for n in range(_enemy_quantity):
		var new_enemy = ENEMY_SCENE.instantiate()
		$"../EnemyManager".add_child(new_enemy)
		new_enemy.name = "enemy"
		var stats = load(Random.get_random_enemy_resource(false))
		new_enemy.max_hp = stats.base_enemy_hp
		await new_enemy.update_enemy_stats(stats)
		new_enemy.enemy_next_action = enemy_choose_action(new_enemy)
		enemies.append(new_enemy)
		await get_tree().process_frame
		new_enemy.update_next_action_texture()
		if not new_enemy.is_node_ready():
			await new_enemy.ready
		
		await get_tree().process_frame

func spawn_boss_enemy():
	var new_enemy = ENEMY_SCENE.instantiate()
	$"../EnemyManager".add_child(new_enemy)
	new_enemy.name = "BOSS_ENEMY"
	var stats = load(Random.get_random_enemy_resource(true))
	new_enemy.max_hp = stats.base_enemy_hp
	await new_enemy.update_enemy_stats(stats)
	
	new_enemy.enemy_next_action = enemy_choose_action(new_enemy)
	enemies.append(new_enemy)
	
	new_enemy.update_next_action_texture()



func alternate_update_enemy_positions() -> void:
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	
	var starting_enemy_x_position = center_screen_x
	var starting_enemy_y_position = center_screen_y + center_screen_y / 4
	
	#change scale of enemies
	for enemy in enemies:
		enemy.enemy_scale = Globals.card_scale_factor
		if enemy.stats.is_boss_enemy:
			enemy.enemy_scale *= 1.25
		enemy.scale = Vector2(enemy.enemy_scale, enemy.enemy_scale)
		
		
	
	var row: int = 0
	var column: int = 0
	
	for enemy in enemies:
		if starting_enemy_x_position + enemy.texture_size.x * enemy.scale.x * column < center_screen_x*2:
			enemy.position.y = starting_enemy_y_position - (enemy.texture_size.y * enemy.scale.y) * row
			enemy.position.x = starting_enemy_x_position + enemy.texture_size.x * enemy.scale.x * column
			column += 1
		else:
			column = 0
			row += 1
			enemy.position.x = starting_enemy_x_position + enemy.texture_size.x * enemy.scale.x * column
			enemy.position.y = starting_enemy_y_position - (enemy.texture_size.y * enemy.scale.y) * row
	await get_tree().process_frame

	


func update_enemy_labels():
	for n in enemies:
		n.emit_signal("healthChanged")

func enemy_turn():
	#loops through enemies

	for _enemy in enemies:
		
		if is_instance_valid(player) and is_inside_tree():
			player.emit_signal("healthChanged")
			await enemy_action(_enemy,_enemy.enemy_next_action)
			_enemy.enemy_next_action = enemy_choose_action(_enemy)
			print(_enemy.enemy_next_action)
			_enemy.update_next_action_texture()
	
	if is_instance_valid(player) and is_inside_tree():
		player.emit_signal("healthChanged")
		await get_tree().process_frame
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
			await attack(player,_enemy.attack)
		elif action == "defend":
			await add_shield(_enemy, _enemy.shield_attack)
			_enemy.emit_signal("healthChanged")

func enemy_death(target):
	enemies.erase(target)
	await card_used
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
		
	$"../ParticleManager".play_particle_MusicNoteExplosion(target.position)
	await get_tree().create_timer(1.0).timeout
	
	if target.hp <= 0:
		if target is enemy_class:
			enemy_death(target)
		elif target is player_class:
			player_death(target)


func add_shield(target, shield_added):
	$"../ParticleManager".play_particle_shieldUp(target.position)
	await get_tree().create_timer(1.0).timeout
	target.shield += shield_added

func heal(target, health):
	target.hp += health
	$"../ParticleManager".play_particle_healUp(target.position)
	await get_tree().create_timer(1.0).timeout
	if target is player_class:
		if target.hp > target.max_hp:
			target.hp = target.max_hp
	

func battle_loop():
	while battle:
		if enemies.size() > 0:
			await get_tree().process_frame
			alternate_update_enemy_positions()
			#update_enemy_positions()
			if is_player_turn:
				await player_turn()
			else:
				await enemy_turn()
		else:
			battle_ends()

func battle_ends():
	
	battle = false
	if SaveManager.save_file_data.current_icon == 5:
		SaveManager.save_file_data.current_icon = 0
		SaveManager.save_file_data.world_difficulty += 1
	else:
		SaveManager.save_file_data.current_icon += 1
		
	await save_to_savefile()
	
	if SaveManager.save_file_data.world_difficulty == 4:
		SignalManager.change_scene_to_win()
	else:
		SignalManager.change_scene_to_rewards()



	
