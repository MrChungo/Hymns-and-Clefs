extends Node2D

const USED_CARD_SLOT_REFERENCE = preload("uid://bc446000gge8c")

var global_rarities = load("uid://dxut7bry6abc") #RANDOM_REFERENCE.get_weighted_rarity()

var temp_rewards_deck = []
var card_slot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_setup()
	await get_tree().process_frame
	button_pos_setup()
	show_buttons()
	

func button_pos_setup():
	
	
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	
	var upper_location = center_screen_y - center_screen_y / 4
	var lower_location = center_screen_y + center_screen_y / 4
	var leftmost_location = center_screen_x - center_screen_x / 4
	var rightmost_location = center_screen_x + center_screen_x / 4

	$Control/new_card.position = Vector2(leftmost_location - ($Control/new_card.pivot_offset.x), upper_location - ($Control/new_card.pivot_offset.y))
	$Control/remove_card.position = Vector2(rightmost_location - ($Control/remove_card.pivot_offset.x), upper_location - ($Control/remove_card.pivot_offset.y))
	$Control/heal.position = Vector2(leftmost_location - ($Control/heal.pivot_offset.x), lower_location - ($Control/heal.pivot_offset.y))
	$Control/"max_hp+".position = Vector2(rightmost_location - ($Control/"max_hp+".pivot_offset.x), lower_location - ($Control/"max_hp+".pivot_offset.y))
	
	for button in $Control.get_children():
		button.button_scale = Globals.card_scale_factor
		button.scale = Vector2(button.button_scale, button.button_scale)

func show_buttons():
	%Deck.visible = false
	$Control/new_card.visible = true
	$Control/remove_card.visible = true
	$Control/heal.visible = true
	$Control/"max_hp+".visible = true
	
func hide_buttons():
	$Control/new_card.visible = false
	$Control/remove_card.visible = false
	$Control/heal.visible = false
	$Control/"max_hp+".visible = false
	
	
func _on_new_card_pressed() -> void:
	hide_buttons()
	get_random_cards()
	center_deck_position()
	%Deck.visible = true
	create_card_slot()
	await %card_manager.card_used_on_enemy
	SaveManager.save_file_data.deck.deck_resource.append(card_slot.card_in_slot.stats)
	leave_rewards_screen()
	
func draw_cards_to_hand():
	for n in range(SaveManager.save_file_data.hand_size):
		%Deck.draw_card()

func get_random_cards():
	
	for n in range(SaveManager.save_file_data.hand_size):
		var rarity = Random.get_weighted_rarity_by_world(global_rarities.card_type_rarities)
		%Deck.deck.append(load(Random.get_random_card_resource(rarity)))
		
	for n in range(len(%Deck.deck)):
		%Deck.draw_card()

func create_card_slot():
	card_slot = USED_CARD_SLOT_REFERENCE.instantiate()
	$".".add_child(card_slot)
	card_slot.name = "CardSlot"
	card_slot.position = Vector2(Globals.center_screen_x,Globals.center_screen_y)

func center_deck_position():
	%Deck.position = Vector2(Globals.center_screen_x,Globals.center_screen_y)


func _on_remove_card_pressed() -> void:
	hide_buttons()
	create_card_slot()
	%Deck.load_from_save()
	draw_cards_to_hand()
	center_deck_position()
	%Deck.visible = true
	
	await %card_manager.card_used_on_enemy
	
	empty_hand()
	%Deck.renew_deck()
	%Deck.save_to_savefile()
	leave_rewards_screen()
	

func empty_hand():
	var hand_ref = %Hand
	var deck_ref = %Deck
	
	for n in hand_ref.player_hand:
		deck_ref.send_card_to_discard(n)
	hand_ref.player_hand.clear()


func _on_heal_pressed() -> void:
	SaveManager.save_file_data.current_player_hp = SaveManager.save_file_data.max_player_hp
	leave_rewards_screen()


func _on_max_hp_pressed() -> void:
	SaveManager.save_file_data.max_player_hp += 10
	leave_rewards_screen()
	

func leave_rewards_screen():
	SaveManager._save()
	SignalManager.change_scene_to_map()




func background_setup():
	var background_scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	
	$Background.position.x = Globals.center_screen_x 
	$Background.position.y = Globals.center_screen_y
	
	$Background.scale = Vector2(background_scale,background_scale)
	















	
