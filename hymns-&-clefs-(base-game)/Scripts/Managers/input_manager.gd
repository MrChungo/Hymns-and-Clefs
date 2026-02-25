extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released

const COLLISION_MASK_CARD := 1
const COLLISION_MASK_DECK := 4

var card_manager_reference
var deck_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var current_scene = get_tree().current_scene
	if current_scene.has_node("Deck"): #"res://Scenes/card_stuffs/deck.tscn"
		deck_reference = %Deck
	if current_scene.has_node("card_manager"): #"res://Scenes/Managers/card_manager.tscn"
		card_manager_reference = %card_manager

	
func _input(event):
	#checks list of all events (key inputs)
	#checks the type of event (use this for later reference)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
			


func raycast_at_cursor():
	#checks if card is below mouse position
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK_CARD:
			#card clicked
			var card_found = result[0].collider.get_parent()
			if card_found and (card_found is card_class):
				card_manager_reference.start_drag(card_found)
		elif result_collision_mask == COLLISION_MASK_DECK:
			#deck clicked
			#deck_reference.draw_card() #player does not draw manually
			pass
