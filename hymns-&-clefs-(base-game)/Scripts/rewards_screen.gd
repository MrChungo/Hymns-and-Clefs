extends Node2D

var global_rarities = load("uid://dxut7bry6abc") #RANDOM_REFERENCE.get_weighted_rarity()

var temp_rewards_deck = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



func _on_upgrade_pressed() -> void:
	print("a")

func get_random_card():
	var rarity = Random.get_weighted_rarity_by_world(global_rarities.card_type_rarities)
	print(rarity)
	if rarity == "common":
		pass
	elif rarity == "uncommon":
		pass
	elif rarity == "rare":
		pass

func draw_cards_to_hand():
	var deck_ref = %Deck
	for n in range(SaveManager.save_file_data.hand_size):
		deck_ref.draw_card()


func _on_new_card_pressed() -> void:
	get_random_card()
