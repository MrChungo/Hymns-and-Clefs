extends Node2D

signal note_used()
signal remove_from_old_array(note)
signal add_note_to_hand(note)

const COLLISION_MASK_NOTE := 8
const COLLISION_MASK_NOTE_SLOT := 16

var screen_size
var note_being_dragged
var is_hovering_on_note
var battle_chord_system_reference

@onready var note_scale = Globals.center_screen_x/280


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	battle_chord_system_reference = get_parent()
	var input_manager = get_tree().current_scene.get_node("InputManager")
	input_manager.start_note_drag.connect(start_drag)
	input_manager.left_mouse_button_released.connect(on_left_click_released)
	input_manager.right_mouse_button_released.connect(on_right_click_released)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if note_being_dragged:
		var mouse_pos = get_global_mouse_position()
		note_being_dragged.position = Vector2(clamp(mouse_pos.x,0, screen_size.x),clamp(mouse_pos.y,0, screen_size.y))


func start_drag(note):
	note_being_dragged = note
	note_being_dragged.scale = Vector2(note_scale,note_scale)

func finish_drag():
	note_being_dragged.scale = Vector2(note_scale+0.5,note_scale+0.5)
	var note_slot_found = raycast_check_for_note_slot()
	if note_slot_found and (note_slot_found is staffLineClass):
		#note dropped in empty note slot
		note_being_dragged.z_index = -1
		note_being_dragged.line_note_is_in = note_slot_found
		battle_chord_system_reference.remove_note_from_hand(note_being_dragged)
		note_being_dragged.position = note_slot_found.position
		
		if (note_slot_found is staffLineClass) :
			remove_from_old_array.emit(note_being_dragged)
			note_slot_found.notes_being_held.append(note_being_dragged)
			note_being_dragged.line_note_is_in = note_slot_found
			note_being_dragged.note = note_slot_found.line_defined_note
			note_used.emit()
		else:
			add_note_to_hand.emit(note_being_dragged)
	else:
		if note_being_dragged.line_note_is_in:
			battle_chord_system_reference.remove_note_from_line(note_being_dragged)
			note_being_dragged.line_note_is_in = null
		while note_being_dragged.type != "natural":
			note_being_dragged.shift_note_type()
		battle_chord_system_reference.add_note_to_hand(note_being_dragged)
	note_being_dragged = null
	
	


func connect_note_signals(note):
	note.connect("note_hovered", on_hovered_over_note)
	note.connect("note_hovered_off", on_hovered_off_note)


func on_left_click_released():
	if note_being_dragged:
		finish_drag()

func on_right_click_released():
	if note_being_dragged:
		finish_drag()
		#note_being_dragged.change_note_type()


func on_hovered_over_note(note):
	if !is_hovering_on_note:
		is_hovering_on_note = true
		highlight_note(note,true)

func on_hovered_off_note(note):
	#check if note is NOT in a note slot and is NOT being dragged
	if !note_being_dragged:
		#if not dragging
		highlight_note(note, false)
		#check if hovered off note straight on to another note
		var new_note_hovered = raycast_check_for_note()
		if new_note_hovered:
			highlight_note(new_note_hovered, true)
		else:
			is_hovering_on_note = false


func highlight_note(note, hovered):
	if hovered:
		note.scale = Vector2(note_scale+0.5,note_scale+0.5)
		note.z_index = 2
	else:
		note.scale = Vector2(note_scale,note_scale)
		note.z_index = 1
		

func raycast_check_for_note_slot():
	#checks if note is below mouse position
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_NOTE_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#print(result[0].collider.get_parent())
		return result[0].collider.get_parent()
	else:
		return null

func raycast_check_for_note():
	#checks if note is below mouse position
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_NOTE
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return get_note_with_highest_z_index(result)
	else:
		return null


func get_note_with_highest_z_index(notes):
	#asume first note passed has the highest z index
	var highest_z_note = notes[0].collider.get_parent()
	var highest_z_index = highest_z_note.z_index
	
	#loop through rest of the notes & check for a higher z index
	
	for i in range(1, notes.size()):
		var current_note = notes[i].collider.get_parent()
		if current_note.z_index > highest_z_index:
			highest_z_note = current_note
			highest_z_index = current_note.z_index
	return highest_z_note
