extends Node2D
class_name CardManagerClass

signal card_used_on_enemy(enemy_target:enemy_class) ## Signal sent when a card is used on an enemy

const COLLISION_MASK_CARD:int = 1
const COLLISION_MASK_CARD_SLOT:int = 2

var screen_size
var card_being_dragged:card_class
var is_hovering_on_card:bool
var player_hand_reference

@onready var card_scale:int = round(Globals.center_screen_x/250)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = %Hand
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0, screen_size.x),clamp(mouse_pos.y,0, screen_size.y))

## This method scales down a card when it's starting to be dragged and adds it to [br]
## [member card_being_dragged]
func start_drag(card:card_class) -> void:
	card_being_dragged = card
	card_being_dragged.scale = Vector2(card_scale,card_scale)

## This method is called when a card is finished being dragged. If a card is on a [br]
## [card_slot_class], it will place that card on the [card_slot_class]. If it's not over a [br]
## [card_slot_class], it will return the [card_class] back to hand.
func finish_drag() -> void:
	card_being_dragged.scale = Vector2(card_scale+0.5,card_scale+0.5)
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		#card dropped in empty card slot
		card_being_dragged.z_index = -1
		card_being_dragged.card_slot_card_is_in = card_slot_found
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		card_being_dragged.position = card_slot_found.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.card_in_slot = card_being_dragged
		if (card_slot_found is enemy_class) or (card_slot_found is card_slot_class) :
			card_used_on_enemy.emit(card_slot_found)
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged, card_being_dragged.position_in_hand)
	card_being_dragged = null
	
	

## This method connects the card signals
func connect_card_signals(card:card_class) -> void:
	card.connect("card_hovered", on_hovered_over_card)
	card.connect("card_hovered_off", on_hovered_off_card)

## This method calls upon [method finish_drag] when a card is released by the mouse.
func on_left_click_released() -> void:
	if card_being_dragged:
		finish_drag()

## This method will highlight a card if the mouse is hovering over it.
func on_hovered_over_card(card:card_class) -> void:
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card,true)

## This method will return a card back to small when it's stopped being hovered.
func on_hovered_off_card(card:card_class) -> void:
	#check if card is NOT in a card slot and is NOT being dragged
	if !card.card_slot_card_is_in && !card_being_dragged:
		#if not dragging
		highlight_card(card, false)
		#check if hovered off card straight on to another card
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

# This method scales up a card when it's being hovered. And scales down when it's being not.
func highlight_card(card:card_class, hovered:bool) -> void:
	if hovered:
		card.scale = Vector2(card_scale+0.5,card_scale+0.5)
		card.z_index = 2
	else:
		card.scale = Vector2(card_scale,card_scale)
		card.z_index = 1
		
## THis method checks if there is a slot where a [card_class] can be put into.
func raycast_check_for_card_slot():
	#checks if card is below mouse position
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null

## This method checks if there's a [card_class] under the mouse cursor.
func raycast_check_for_card():
	#checks if card is below mouse position
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return get_card_with_highest_z_index(result)
	else:
		return null

##This method gets the highest z-index [card_class] from an [Array]
func get_card_with_highest_z_index(cards):
	#asume first card passed has the highest z index
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	#loop through rest of the cards & check for a higher z index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
