extends Node2D

signal chord_checked

const DEFAULT_CARD_MOVE_SPEED = 0.1
const NOTE_SCENE = preload("uid://21biyctn0unu")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/note.tscn"
const STAFF_SCENE = preload("uid://cavmm10t43b7r")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff.tscn"


var staff
var target_chords = []
var notes = []
var labels = []
@onready var overall_scale = Globals.center_screen_x/280
@onready var note_y_position = Globals.center_screen_y + Globals.center_screen_y / 1.5

var last_chord_check = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#load_battle_chord_system(2)
	$NoteManager.note_used.connect(update_staff)
	$NoteManager.remove_from_old_array.connect(remove_note_from_line)
	$NoteManager.add_note_to_hand.connect(add_note_to_hand)

func load_battle_chord_system(chords):
	set_up_staff(chords)
	get_chords(chords)
	spawn_notes()
	update_note_hand_positions()
	spawn_note_labels()
	staff.align_label(labels)

func set_up_staff(segments):
	$SubmitChords.visible = true
	
	staff = STAFF_SCENE.instantiate()
	staff.load_staff(segments)
	staff.position.x = Globals.center_screen_x
	staff.position.y = Globals.center_screen_y + Globals.center_screen_y/4
	staff.scale = Vector2(overall_scale,overall_scale)
	$".".add_child(staff)

func get_chords(chords):
	for n in range(chords):
		target_chords.append($ChordManager.gen_chord())
	#print(target_chords)


func spawn_notes():
	for chord in target_chords:
		for note in chord:
			note = NOTE_SCENE.instantiate()
			note.position.x = Globals.center_screen_x
			note.position.y = Globals.center_screen_y + Globals.center_screen_y/4
			note.scale = Vector2(overall_scale,overall_scale)
			$NoteManager.add_child(note)
			notes.append(note)
	
func update_note_hand_positions():
	for i in range(notes.size()):
		#get new card position based on index
		var new_position = Vector2(calculate_note_hand_position(i), note_y_position)
		var note = notes[i]
		note.position_in_hand = new_position
		animate_note_to_position(note, new_position)

func calculate_note_hand_position(index):
	var note_width =  notes[-1].get_node("NoteSprite").texture.get_width()*overall_scale
	var total_width = note_width * notes.size()
	
	var x_offset = Globals.center_screen_x + (index * note_width) - (total_width / 2.0)
	return x_offset


func animate_note_to_position(note, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(note, "position", new_position, DEFAULT_CARD_MOVE_SPEED)

func add_note_to_hand(note):
	if note not in notes:
		notes.insert(0, note)
		update_note_hand_positions()
	else:
		animate_note_to_position(note, note.position_in_hand)


func remove_note_from_hand(note):
	if note in notes:
		notes.erase(note)
		update_note_hand_positions()



func remove_note_from_line(note):
	for measure in staff.lines:
		for line in measure:
			for line_note in line.notes_being_held:
				if line_note == note:
					line.notes_being_held.erase(note)
	update_staff()


func update_staff():
	staff.align_notes()




func _on_submit_chords_pressed() -> void:
	var are_chords_true = false
	var chord_check_container = target_chords.duplicate(true)
	
	#checks every note in chord
	for chord in len(target_chords):
		for measure in staff.lines:
			for line in measure:
					for note in line.notes_being_held:
						for chord_note in target_chords[chord]:
							if chord_note == note.get_note_name_with_type():
								chord_check_container[chord].erase(chord_note)
								
	for container in chord_check_container:
		are_chords_true = true
		for note in container:
			are_chords_true = false
	last_chord_check = are_chords_true
	
	if !are_chords_true:
		chord_check_container.clear()
		print(target_chords)
		for n in target_chords:
			chord_check_container.append($ChordManager.swap_flats_and_sharps((n.duplicate(true))))
		print(chord_check_container)
		
		#checks every note in chord
		for chord in len(target_chords):
			for measure in staff.lines:
				for line in measure:
						for note in line.notes_being_held:
							for chord_note in target_chords[chord]:
								if chord_note == note.get_note_name_with_type():
									chord_check_container[chord].erase(chord_note)
		for container in chord_check_container:
			are_chords_true = true
			for note in container:
				are_chords_true = false
		last_chord_check = are_chords_true
	
	chord_checked.emit()

func spawn_note_labels():
	for chord in len(target_chords):
		var new_chord_label = RichTextLabel.new()
		new_chord_label.bbcode_enabled = true
		
		var chord_text: String
		
		if SaveManager.save_file_data.world_difficulty == 1:
			chord_text = $ChordManager.get_chord_name(target_chords[chord])  + "[br]" + $ChordManager.get_string_chord_notes(target_chords[chord])
		elif SaveManager.save_file_data.world_difficulty == 2:
			if $ChordManager.get_chord_type(target_chords[chord]) in ["major", "minor"]:
				chord_text = $ChordManager.get_chord_name(target_chords[chord])
			else:
				chord_text = $ChordManager.get_chord_name(target_chords[chord]) + "[br]" + $ChordManager.get_string_chord_notes(target_chords[chord])
		elif SaveManager.save_file_data.world_difficulty == 3:
			chord_text = $ChordManager.get_chord_name(target_chords[chord])
		else:
			chord_text = $ChordManager.get_chord_name(target_chords[chord])
		
		var text_size = round(Globals.center_screen_x / 15)
		new_chord_label.text = "[font_size=%d]%s[/font_size]" % [text_size, chord_text]
		
		new_chord_label.fit_content = true
		new_chord_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		new_chord_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		$".".add_child(new_chord_label)
		new_chord_label.size = new_chord_label.get_minimum_size()
		
		
		new_chord_label.pivot_offset = new_chord_label.size / 2.0
		
		var half_width = (new_chord_label.size.x * new_chord_label.scale.x) / 2.0
		
		#new_chord_label.global_position.x = staff.lines[chord][0].global_position.x 
		new_chord_label.global_position.x = staff.lines[chord][0].global_position.x - half_width
		
		
		
		
		new_chord_label.name = "chord: " + $ChordManager.get_chord_name(target_chords[chord])
		
		
		
		labels.append(new_chord_label)
		
		











	
