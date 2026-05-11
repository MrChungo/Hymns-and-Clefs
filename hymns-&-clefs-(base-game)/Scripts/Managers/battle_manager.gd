extends Node2D

# THIS FILE MUST BE AT THE BOTTOM OF THE TREE FOR EVERYTHING TO WORK

const BATTLE_CHORD_SYSTEM_SCENE = preload("uid://b6oxxvrroq6ke")#"res://Scenes/Music Battle System Stuffs/Battle_Chord_system.tscn"
const PLAYER_SCENE = preload("uid://bys0uidt8s34i")#"res://Scenes/player/player.tscn"
const ENEMY_SCENE :=  preload("uid://448b5kjxjtf5") #res://Scenes/enemies/enemy.tscn
const MAX_ENEMIES_PER_ROW:int = 4
const VERTICAL_ENEMY_SPACING:int = 125
const HORIZONTAL_ENEMY_SPACING:int = 100

signal card_used(enemy:enemy_class) ##Signal is sent when a card is used on an enemy.

var global_rarities = load("uid://dsdqu3nm2dwxg") #"res://Resources/Misc/default_global_rarities.tres"
var test_save = load("uid://chmnudsaqsjho") #"res://Resources/Save States/Test_Battle_save.tres"

var save: save_resource

var difficulty : int
var battle_round :int
var is_player_turn : bool
var waiting_for_action: bool
var battle: bool

#player spawning and stuffs
var player: player_class
var hand_size: int
var card_being_used: Node2D

#battle runtime stuff
var battle_chord_system: BattleChordSystemClass

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

#region Battle Loop Methods
## This method sets up the battle by creating a [player_class], and enemies. [br]
## In addition it sets up the enemy next action labels and also the enemy and player [br]
## health/shield bars.
func battle_setup() -> void:
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


## This method runs the turn based part of the battle. IT also updates enemy positions [br]
## Every turn just in case the player kills any.
func battle_loop() -> void:
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

##This method occurs when the battle ends and saves the game, and sends the player to [br]
## either [RewardsScreenClass] or [WinScreenClass]. In addition it changes [SaveManagerClass.save_file_data.world_difficulty] when [br]
## beating a boss, and changes [SaveManagerClass.save_file_data.current_icon] by one when just advancing [br]
## to the next level.
func battle_ends() -> void:
	
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
#endregion

#region Save related methods
## This method loads relevant player and world data from [SaveManagerClass.save_file_data] [br]
## that is required for the battle to work.
func load_from_save() -> void:

	SaveManager._load()
	player.load_player_stats()
	#player.hp = 6666666666666
	await %Deck.load_from_save()
	difficulty = SaveManager.save_file_data.world_difficulty
	hand_size = SaveManager.save_file_data.hand_size
	
	
## This method saves [player_class] and [DeckClass] data to permanent memory.
func save_to_savefile() -> void:
	player.save_player_stats()
	await %Deck.save_to_savefile()
	SaveManager._save()
#endregion

#region Player Methods

## This method spawns a [player_class] and sets it's position and scale.
func spawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	$"..".add_child.call_deferred(player)
	player.name = "player"

	player.global_position.y = (screen_height/2.0)

	player.global_position.x = (screen_width/8.0)
	
	var player_scale_factor = Globals.card_scale_factor*2
	player.scale = Vector2(player_scale_factor,player_scale_factor)

## This function plays out the player turn algorythm. Here it draws cards from [br]
## [DeckClass] to hand and then awaits for the player to use trhe card to an enemy. [Br]
## Then, it loads [BattleChordSystemClass], and if the player does a successful chord check [br]
## it makes the card actually act on the enemy.
func player_turn() -> void:
	draw_cards_to_hand()
	
	#checks if card is in slot
	await %card_manager.card_used_on_enemy
	
	var target = select_target()
	
	await use_card(target, target.card_in_slot)

	
	player.emit_signal("healthChanged")
	update_enemy_labels()
	is_player_turn = false

## This method kills the player and changes scene to [DeathSceneClass]
func player_death(target:player_class) -> void:
	battle = false
	target.death()
	SignalManager.change_scene_to_death()
#endregion

#region Card logic

##This method returns an [enemy_class] who has a [card_class] on it's [member enemy_class.card_in_slot]
func select_target():
	for n in enemies:
		if n.card_in_slot:
			return n

## This method uses a [card_class] inputted on [param card], and applies the card effects [br]
## on a [param target]. In addition to this, it loads calls [method load_battle_chord_system], and [br]
## once used, it calls [unload_battle_chord_system] and calls [signal card_used] on [param target].
func use_card(target, card:card_class) -> void:
	empty_hand()
	card.visible = false
	
	await load_battle_chord_system(card)
	battle_chord_system.visible = false
	if battle_chord_system.last_chord_check: #if all chords are correct it uses the card
		if card.stats.attack_points > 0:
			await attack(target, card.stats.attack_points)
		if card.stats.shield_points > 0:
			await add_shield(player, card.stats.shield_points)
		if card.stats.health_gain > 0:
			await heal(player, card.stats.health_gain)
	
	unload_battle_chord_system()
	emit_signal("card_used", target)

## This method draws cards to hand.
func draw_cards_to_hand() -> void:
	var deck_ref = %Deck
	for n in range(hand_size):
		deck_ref.draw_card()
	if len(%Hand.player_hand) < hand_size:
		for n in range(hand_size - len(%Hand.player_hand)):
			deck_ref.draw_card()


## This method empties the hand by sending all the cards to [member DeckClass.discard_pile]
func empty_hand() -> void:
	var hand_ref = %Hand
	var deck_ref = %Deck
	
	for n in hand_ref.player_hand:
		deck_ref.send_card_to_discard(n)
	hand_ref.player_hand.clear()
#endregion

#region Battle Chord System methods

##This method loads a [BattleChordSystemClass] where the measures deppend on [br]
##The card's rarity. Common cards = 1 measure, Uncommon cards = 2 measures, Rare cards = 4 measures. [br]
## Then it awaits for the player to finish the chord check to contine.
func load_battle_chord_system(card:card_class) -> void:
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
	#print("chord checked")

## This method unloads the [BattleChordSystemClass]
func unload_battle_chord_system() -> void:
	battle_chord_system.queue_free()
	battle_chord_system = null
#endregion

#region enemy methods

## This method spawns enemies according to [param _enemy_quantity]. The enemies spawned [br]
## are given random enemy stats, given a next action and added to the tree, and [member enemies]. [br]
## [b]Important to not that this DOES NOT SPAWN BOSSES, that is handled by [method spawn_boss_enemy] [/b]
func spawn_enemies(_enemy_quantity:int) -> void:
	for n in range(_enemy_quantity):
		var new_enemy = ENEMY_SCENE.instantiate()
		$"../EnemyManager".add_child(new_enemy) #adds enemy to tree, used for rendering
		new_enemy.name = "enemy"
		var stats = load(Random.get_random_enemy_resource(false)) #gets random enemy (based on world diff)
		new_enemy.max_hp = stats.base_enemy_hp
		await new_enemy.update_enemy_stats(stats)
		new_enemy.enemy_next_action = enemy_choose_action(new_enemy)
		enemies.append(new_enemy)
		await get_tree().process_frame
		new_enemy.update_next_action_texture()
		if not new_enemy.is_node_ready():
			await new_enemy.ready
		
		await get_tree().process_frame

## This method spawns a boss enemy according to the current world difficulty. Works [br]
## similarly as [method spawn_enemies]
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


## This method updates the enemy positions from [member enemies] to fit well within each other [br]
## and within the screen size.
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


## This method updates the health, and shield bars for all enemies in [member enemies].
func update_enemy_labels() -> void:
	for n in enemies:
		n.emit_signal("healthChanged")

## This method cycles through all of the enemies in [member enemies], and makes them [br]
## use their [enemy_class.enemy_next_action], then it selects their next action [br]
## updates their labels, and moves it to the player's turn.
func enemy_turn() -> void:
	#loops through enemies

	for _enemy in enemies:
		
		if is_instance_valid(player) and is_inside_tree():
			player.emit_signal("healthChanged")
			await enemy_action(_enemy,_enemy.enemy_next_action)
			_enemy.enemy_next_action = enemy_choose_action(_enemy)
			_enemy.update_next_action_texture()
	
	if is_instance_valid(player) and is_inside_tree():
		player.emit_signal("healthChanged")
		await get_tree().process_frame
		update_enemy_labels()
	is_player_turn = true

## This method is used to choose the next action of an [enemy_class]. It reads their [br]
## enemy type, and deppending on this it will get a random action from [global_rarities_resource] [br]
## and set it for the enemie's next action.
func enemy_choose_action(_enemy:enemy_class) -> String:
	var enemy_action_type = _enemy.enemy_action_type
	var action = "doNothing" 
	if enemy_action_type == 0: #balanced
		action = Random.get_weighted_rarity(global_rarities.enemy_balanced_attack_rarity)
	elif enemy_action_type == 1: #attacker
		action = Random.get_weighted_rarity(global_rarities.enemy_attacker_attack_rarity)
	elif enemy_action_type == 2: #defender
		action = Random.get_weighted_rarity(global_rarities.enemy_defender_attack_rarity)
	
	return action

## This method makes an enemy do their next action. In addition to this,
## it updates enemy labels if needed.
func enemy_action(_enemy:enemy_class, action:String):
	if action != "doNothing":
		if action == "attack":
			await attack(player,_enemy.attack)
		elif action == "defend":
			await add_shield(_enemy, _enemy.shield_attack)
			_enemy.emit_signal("healthChanged")

## This method is called when an [enemy_class] must die. If safely erases the [br]
## enemy, and allows for card system to not explode due to missing reference issues.
func enemy_death(target):
	enemies.erase(target)
	await card_used
	await target.death()
#endregion

#region Enemy and Player usable methods

## This method performs an attack to a [param target], this can be either a [player_class], [br]
## or an [enemy_class]. The value of the attack is found in the parameter [param damage].
func attack(target:Node2D, damage:int) -> void:
	
	if target.shield > 0: ## this is the part of the code that makes damage not penetrate the shield.
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

## This method adds shield to a [param target], this can be either a [player_class], [br]
## or an [enemy_class]. The value of the attack is found in the parameter [param damage].
func add_shield(target:Node2D, shield_added:int) -> void:
	$"../ParticleManager".play_particle_shieldUp(target.position)
	await get_tree().create_timer(1.0).timeout
	target.shield += shield_added

## This method heals a [param target], this can be either a [player_class], [br]
## or an [enemy_class]. The value of the attack is found in the parameter [param damage]. [br]
## Important: The health cannot exceed the [param target]'s max health.
func heal(target, health):
	target.hp += health
	$"../ParticleManager".play_particle_healUp(target.position)
	await get_tree().create_timer(1.0).timeout
	if target is player_class:
		if target.hp > target.max_hp:
			target.hp = target.max_hp
#endregion



	
