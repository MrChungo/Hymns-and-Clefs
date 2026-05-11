extends Node2D
## This node holds a bunch of sprites on a "Hand" at the bottom of the screen
## code here is based on the series Godot 4 CARD GAME from Barry's Dev Hell, on youtube [br]
## find it on [url] https://youtube.com/playlist?list=PLNWIwxsLZ-LMYzxHlVb7v5Xo5KaUV7Tq1&si=W6UocyFLIWn6tzMn [/url]
class_name HandClass


const CARD_SCENE_PATH := "res://Scenes/card_stuffs/card.tscn"
const CARD_WIDTH:int = 100 # THIS IS A MAGICAL NUMBER PLZ SEE IF CAN NOT HARD CODE
const DEFAULT_CARD_MOVE_SPEED := 0.1 # idk if the name works super well but for now it does the job

var player_hand:Array = []

@onready var hand_y_position = Globals.center_screen_y + Globals.center_screen_y / 1.5

# Called when the node enters the scene tree for the first time.

## This method adds a [card_class] to hand.
func add_card_to_hand(card:card_class, speed) -> void :
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.position_in_hand)

## This method updates the positions of all cards in hand.
func update_hand_positions(speed) -> void:
	for i in range(player_hand.size()):
		#get new card position based on index
		var new_position = Vector2(calculate_card_position(i), hand_y_position)
		var card = player_hand[i]
		card.position_in_hand = new_position
		animate_card_to_position(card, new_position, speed)

## This method calculates the current position of a card within an index.
func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var x_offset = Globals.center_screen_x + (index * CARD_WIDTH) - (total_width / 2.0)
	return x_offset

@warning_ignore("unused_parameter")
## This method animates a [card_class] towards a [param new_position].
func animate_card_to_position(card, new_position, speed = DEFAULT_CARD_MOVE_SPEED):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, DEFAULT_CARD_MOVE_SPEED)


##this method removes a card from hand.
func remove_card_from_hand(card:card_class):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
