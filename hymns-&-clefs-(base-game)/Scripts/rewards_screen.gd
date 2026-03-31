extends Node2D

const USED_CARD_SLOT_REFERENCE = preload("uid://bc446000gge8c")

var global_rarities = load("uid://dxut7bry6abc") #RANDOM_REFERENCE.get_weighted_rarity()

var temp_rewards_deck = []
var card_slot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_buttons()

func show_buttons():
	$new_card.visible = true
	$remove_card.visible = true

func hide_buttons():
	$new_card.visible = false
	$remove_card.visible = false


func _on_new_card_pressed() -> void:
	hide_buttons()
	get_random_cards()
	center_deck_position()
	create_card_slot()
	await %card_manager.card_used_on_enemy
	SaveManager.save_file_data.deck.deck_resource.append(card_slot.card_in_slot.stats)
	SaveManager._save()
	SignalManager.change_scene_to_map()
	
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
	
	await %card_manager.card_used_on_enemy
	
	empty_hand()
	%Deck.renew_deck()
	%Deck.save_to_savefile()
	SaveManager._save()
	SignalManager.change_scene_to_map()
	

func empty_hand():
	var hand_ref = %Hand
	var deck_ref = %Deck
	
	for n in hand_ref.player_hand:
		deck_ref.send_card_to_discard(n)
	hand_ref.player_hand.clear()


func _on_heal_pressed() -> void:
	pass # Replace with function body.
