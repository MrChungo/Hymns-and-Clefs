extends Node2D

var global_rarities = load("uid://dxut7bry6abc") #RANDOM_REFERENCE.get_weighted_rarity()

var temp_rewards_deck = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_buttons()

func show_buttons():
	$new_card.visible = true
	$Upgrade.visible = true

func hide_buttons():
	$new_card.visible = false
	$Upgrade.visible = false

func _on_upgrade_pressed() -> void:
	hide_buttons()
	print("a")


func _on_new_card_pressed() -> void:
	hide_buttons()
	get_random_cards()
	
func draw_cards_to_hand():
	var deck_ref = %Deck
	for n in range(SaveManager.save_file_data.hand_size):
		deck_ref.draw_card()

func get_random_cards():
	
	for n in range(SaveManager.save_file_data.hand_size):
		var rarity = Random.get_weighted_rarity_by_world(global_rarities.card_type_rarities)
		%Deck.deck.append(load(Random.get_random_card_resource(rarity)))
		
	for n in range(len(%Deck.deck)):
		%Deck.draw_card()
