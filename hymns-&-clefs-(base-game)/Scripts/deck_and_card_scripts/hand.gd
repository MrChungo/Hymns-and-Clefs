extends Node2D

const CARD_SCENE_PATH := "res://Scenes/card_stuffs/card.tscn"
const CARD_WIDTH := 100 # THIS IS A MAGICAL NUMBER PLZ SEE IF CAN NOT HARD CODE
const HAND_Y_POSITION := 500
const DEFAULT_CARD_MOVE_SPEED := 0.1 # idk if the name works super well but for now it does the job

var player_hand = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	


func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.position_in_hand)


func update_hand_positions(speed):
	for i in range(player_hand.size()):
		#get new card position based on index
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.position_in_hand = new_position
		animate_card_to_position(card, new_position, speed)

func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	@warning_ignore("integer_division")
	var x_offset = center_screen_x + (index * CARD_WIDTH) - (total_width / 2)
	return x_offset

@warning_ignore("unused_parameter")
func animate_card_to_position(card, new_position, speed = DEFAULT_CARD_MOVE_SPEED):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
