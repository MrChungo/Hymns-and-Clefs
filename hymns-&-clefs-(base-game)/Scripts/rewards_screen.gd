extends Node2D


var temp_rewards_deck = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_upgrade_pressed() -> void:
	print("a")

func get_random_card():
	pass

func draw_cards_to_hand():
	var deck_ref = %Deck
	for n in range(SaveManager.save_file_data.hand_size):
		deck_ref.draw_card()


func _on_new_card_pressed() -> void:
	pass # Replace with function body.
