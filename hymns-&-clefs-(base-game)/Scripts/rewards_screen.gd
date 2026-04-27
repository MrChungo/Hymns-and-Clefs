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
	var center_screen_y = Globals.center_screen_y

	
	$Control/new_card.position.y = center_screen_y  - ($Control/heal.pivot_offset.y)
	$Control/remove_card.position.y = center_screen_y  - ($Control/heal.pivot_offset.y)
	$Control/heal.position.y = center_screen_y  - ($Control/heal.pivot_offset.y)
	$Control/"max_hp+".position.y = center_screen_y  - ($Control/heal.pivot_offset.y)
	
	
	
	for button in $Control.get_children():
		button.button_scale = Globals.card_scale_factor*2
		button.scale = Vector2(button.button_scale, button.button_scale)
	order_icons_x_pos()



func order_icons_x_pos():
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
	















	
