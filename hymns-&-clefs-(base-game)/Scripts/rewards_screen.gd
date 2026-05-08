extends Node2D

const USED_CARD_SLOT_REFERENCE = preload("uid://bc446000gge8c")
const PLAYER_MAX_HEALTH_REWARD_QUANTITY = 10

var global_rarities = preload("uid://dsdqu3nm2dwxg") #RANDOM_REFERENCE.get_weighted_rarity()

var temp_rewards_deck:Array = []
var card_slot

@onready var add_or_remove_card_slot_scale = Globals.card_scale_factor*1.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_setup()
	await get_tree().process_frame
	button_pos_setup()
	show_buttons()


## Sets up the position and scale of button objects in the parent node
func button_pos_setup() -> void:
	var center_screen_y = Globals.center_screen_y
	
	for button in $Control.get_children():
		button.button_scale = Globals.card_scale_factor*2
		button.scale = Vector2(button.button_scale, button.button_scale)
		
	$Control/new_card.position.y = center_screen_y  - ($Control/heal.pivot_offset.y)
	
	$Control/remove_card.position.y = center_screen_y  - ($Control/heal.pivot_offset.y)
	
	$Control/heal.position.y = center_screen_y  - ($Control/heal.pivot_offset.y)
	
	$Control/"max_hp+".position.y = center_screen_y  - ($Control/heal.pivot_offset.y)
	
	order_buttons_x_pos()

## sets up the x-position of all buttons in relation to screen width
func order_buttons_x_pos() -> void:
	var screen_width = Globals.center_screen_x*2
	var total_buttons_width = 0.0
	for button in $Control.get_children():
		total_buttons_width += button.texture_normal.region.size.x * button.button_scale
	
	var padding = Globals.center_screen_x / 12
	var usable_width = screen_width - (padding * 2)
	# Calculate spacing (using a fixed width, e.g., screen width)
	var spacing_length = usable_width - total_buttons_width
	var singular_spacing = spacing_length / ($Control.get_child_count() + 1)

	# Calculate the total width of the entire 'row' (icons + gaps)
	var total_row_width = total_buttons_width + (singular_spacing * ($Control.get_child_count() - 1))

	# Start at negative half of the row width so the middle of the row sits at Manager's (0,0)
	var current_x = -total_row_width / 2
	
	for button in $Control.get_children():
		var button_w = button.texture_normal.region.size.x * button.button_scale
		# Position icon relative to the row start
		button.position.x = current_x + (button_w / 2) - button.pivot_offset.x
		# Advance current_x by icon width + spacing
		current_x += button_w + singular_spacing

	# Place the manager in the middle of the screen
	$Control.position.x = Globals.center_screen_x

## makes all buttons visible
func show_buttons() -> void:
	%Deck.visible = false
	$Control/new_card.visible = true
	$Control/remove_card.visible = true
	$Control/heal.visible = true
	$Control/"max_hp+".visible = true

## hides all buttons
func hide_buttons() -> void:
	$Control/new_card.visible = false
	$Control/remove_card.visible = false
	$Control/heal.visible = false
	$Control/"max_hp+".visible = false

## When called, it sets up the scene to add a new card to deck,
## then waits for player to choose a new card.[br]
## changes scene to map after completion
func _on_new_card_pressed() -> void:
	hide_buttons()
	
	center_deck_position()
	%Deck.visible = true
	create_card_slot()
	
	get_random_cards()
	
	await %card_manager.card_used_on_enemy
	SaveManager.save_file_data.deck.deck_resource.append(card_slot.card_in_slot.stats)
	leave_rewards_screen()

## draws cards to hand
func draw_cards_to_hand() -> void:
	for n in range(SaveManager.save_file_data.hand_size):
		%Deck.draw_card()

## spawns three random cards for the player to add to their deck
func get_random_cards() -> void:
	
	for n in range(SaveManager.save_file_data.hand_size):
		var rarity = Random.get_weighted_rarity_by_world(global_rarities.card_type_rarities)
		%Deck.deck.append(load(Random.get_random_card_resource(rarity)))
		
	for n in range(len(%Deck.deck)):
		%Deck.draw_card()

## creates a generic card slot for card selection purposes
func create_card_slot() -> void:
	card_slot = USED_CARD_SLOT_REFERENCE.instantiate()
	$".".add_child(card_slot)
	card_slot.name = "CardSlot"
	card_slot.position = Vector2(Globals.center_screen_x,Globals.center_screen_y)
	card_slot.scale = Vector2(add_or_remove_card_slot_scale,add_or_remove_card_slot_scale)

## makes deck position the center of the screen
func center_deck_position() -> void:
	%Deck.position = Vector2(Globals.center_screen_x,Globals.center_screen_y)
	%Deck.scale = Vector2(add_or_remove_card_slot_scale,add_or_remove_card_slot_scale)

## When called, it sets up the scene to remove a card from deck,
## then waits for player to choose a card.[br]
## changes scene to map after completion
func _on_remove_card_pressed() -> void:
	
	$Control/remove_card.position = Vector2(-$Control/remove_card.pivot_offset.x,Globals.center_screen_y - $Control/remove_card.pivot_offset.y)
	$Control/remove_card.button_scale = add_or_remove_card_slot_scale
	$Control/remove_card.scale = Vector2(add_or_remove_card_slot_scale,add_or_remove_card_slot_scale)
	$Control/remove_card.disabled = true
	hide_buttons()
	$Control/remove_card.visible = true
	create_card_slot()
	%Deck.load_from_save()
	#center_deck_position()
	%Deck.visible = true
	
	draw_cards_to_hand()
	
	await %card_manager.card_used_on_enemy  #reusing enemy code for this XD
	
	$Control/remove_card.disabled = false
	
	empty_hand()
	%Deck.renew_deck()
	%Deck.save_to_savefile()
	leave_rewards_screen()
	

func empty_hand() -> void:
	var hand_ref = %Hand
	var deck_ref = %Deck
	
	for n in hand_ref.player_hand:
		deck_ref.send_card_to_discard(n)
	hand_ref.player_hand.clear()


## When called, it gives the player a full heal.[br]
## changes scene to map after completion
func _on_heal_pressed() -> void:
	SaveManager.save_file_data.current_player_hp = SaveManager.save_file_data.max_player_hp
	leave_rewards_screen()

## When called, give the player more max HP, check hard coded constant
## for specific value.[br]
## changes scene to map after completion
func _on_max_hp_pressed() -> void:
	SaveManager.save_file_data.max_player_hp += PLAYER_MAX_HEALTH_REWARD_QUANTITY
	leave_rewards_screen()
	

## Saves game and changes scene to map
func leave_rewards_screen() -> void:
	SaveManager._save()
	SignalManager.change_scene_to_map()



## Sets up background position and fits the texture to screen width
func background_setup() -> void:
	var background_scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	
	$Background.position.x = Globals.center_screen_x 
	$Background.position.y = Globals.center_screen_y
	
	$Background.scale = Vector2(background_scale,background_scale)
	















	
