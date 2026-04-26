extends Node2D

signal start_note_drag(note)
signal play_note_sound(note)

signal left_mouse_button_clicked
signal left_mouse_button_released

signal right_mouse_button_clicked
signal right_mouse_button_released


const COLLISION_MASK_CARD := 1
const COLLISION_MASK_DECK := 4

const COLLISION_MASK_ENEMY = 2

const COLLISION_MASK_NOTE := 8
const COLLISION_MASK_LINE:= 16


var card_manager_reference
var note_manager_reference
var deck_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_conections()
	

func refresh_conections():
	var current_scene = get_tree().current_scene
	if current_scene.has_node("NoteManager"):
		note_manager_reference = current_scene.get_node("NoteManager")
	if current_scene.has_node("Deck"): #"res://Scenes/card_stuffs/deck.tscn"
		deck_reference = $"../Deck"
	if current_scene.has_node("card_manager"): #"res://Scenes/Managers/card_manager.tscn"
		card_manager_reference = $"../card_manager"
	else:
		card_manager_reference = null
	
func _input(event):
	#checks list of all events (key inputs)
	#checks the type of event (use this for later reference)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor("left")
		else:
			emit_signal("left_mouse_button_released")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			emit_signal("right_mouse_button_clicked")
			raycast_at_cursor("right")
		else:
			emit_signal("right_mouse_button_released")
			


func raycast_at_cursor(mouse_click):
	#checks if card is below mouse position
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	var usable_results = get_usable_results(result)
	
	if result.size() > 0:
		if mouse_click == "left":
			var result_collision_mask
			for n in result:
				if n.collider.collision_mask != COLLISION_MASK_LINE and n.collider.collision_mask != COLLISION_MASK_ENEMY:
					result_collision_mask = n.collider.collision_mask
			
			if result_collision_mask == COLLISION_MASK_CARD:
				#card clicked
				var object_found = usable_results[0].collider.get_parent()
				if object_found and (object_found is card_class):
					card_manager_reference.start_drag(object_found)
			elif result_collision_mask == COLLISION_MASK_DECK:
				#deck clicked
				#deck_reference.draw_card() #player does not draw manually
				pass
			elif result_collision_mask == COLLISION_MASK_NOTE:
				for obj in usable_results:
					var object_found = obj.collider.get_parent()
					if object_found and (object_found is NoteClass):
						start_note_drag.emit(object_found)
		
		elif mouse_click == "right":
			var result_collision_mask
			for n in result:
				if n.collider.collision_mask != COLLISION_MASK_LINE and n.collider.collision_mask != COLLISION_MASK_ENEMY:
					result_collision_mask = n.collider.collision_mask
			
			if result_collision_mask == COLLISION_MASK_NOTE:
				for obj in usable_results:
					var object_found = obj.collider.get_parent()
					if object_found and (object_found is NoteClass):
						if object_found.line_note_is_in:
							object_found.shift_note_type()
							play_note_sound.emit(object_found)
							

func get_usable_results(list):
	var new_list: Array
	for element in list:
			if is_object_able_to_collide_with_mouse(element):
				new_list.append(element)
	return new_list

func is_object_able_to_collide_with_mouse(object):
	if object.collider.collision_mask != COLLISION_MASK_LINE:
		return true
	else:
		return false








	
