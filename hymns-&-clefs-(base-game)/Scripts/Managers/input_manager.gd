extends Node2D
class_name InputManagerClass

signal start_note_drag(note:NoteClass)
signal play_note_sound(note:NoteClass)

signal left_mouse_button_clicked 
signal left_mouse_button_released

signal right_mouse_button_clicked
signal right_mouse_button_released


const COLLISION_MASK_CARD:int = 1
const COLLISION_MASK_DECK:int = 4

const COLLISION_MASK_ENEMY:int  = 2

const COLLISION_MASK_NOTE:int = 8
const COLLISION_MASK_LINE:int = 16


var card_manager_reference
var note_manager_reference
var deck_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_conections()
	
## This method refreshes connections to [NodeManagerClass], [DeckClass], and [br]
## [CardManagerClass], deppending on what is found in the tree at the time.
func refresh_conections() -> void:
	var current_scene = get_tree().current_scene
	if current_scene.has_node("NoteManager"):
		note_manager_reference = current_scene.get_node("NoteManager")
	if current_scene.has_node("Deck"): #"res://Scenes/card_stuffs/deck.tscn"
		deck_reference = $"../Deck"
	if current_scene.has_node("card_manager"): #"res://Scenes/Managers/card_manager.tscn"
		card_manager_reference = $"../card_manager"
	else:
		card_manager_reference = null

## This method Checks for inputs and releases signals depending on these inputs.
func _input(event) -> void:
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
			

## This method checks if there's anything under the cursor. If the mouse clicks, [br]
## and it's a left click, it will start dragging whatever [NoteClass], or [CardClass], underneath it. [br]
## If it's a right click, it will cycle a [NoteClass]'s type.
func raycast_at_cursor(mouse_click) -> void:
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
							

## This method, returns items that are allowed to collide with the mouse.
func get_usable_results(list) -> Array:
	var new_list: Array
	for element in list:
			if is_object_able_to_collide_with_mouse(element):
				new_list.append(element)
	return new_list

## This methodif an object is allowed to collide with the mouse.
func is_object_able_to_collide_with_mouse(object)  -> bool:
	if object.collider.collision_mask != COLLISION_MASK_LINE:
		return true
	else:
		return false








	
