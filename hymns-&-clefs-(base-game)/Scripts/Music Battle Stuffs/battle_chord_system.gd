extends Node2D

signal chord_checked

const DEFAULT_CARD_MOVE_SPEED = 0.1
const NOTE_SCENE = preload("uid://21biyctn0unu")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/note.tscn"
const STAFF_SCENE = preload("uid://cavmm10t43b7r")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff.tscn"


var staff
var target_chords = []
var notes = []
var labels = []
var text_size = round(Globals.center_screen_x / 15)

@onready var overall_scale = Globals.center_screen_x/280
@onready var note_y_position = Globals.center_screen_y + Globals.center_screen_y / 1.5

var last_chord_check = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#load_battle_chord_system(2)
	$NoteManager.note_used.connect(update_staff)
	$NoteManager.remove_from_old_array.connect(remove_note_from_line)
	$NoteManager.add_note_to_hand.connect(add_note_to_hand)
	$NoteManager.play_note_sound.connect(play_note_sound)
	$"../InputManager".play_note_sound.connect(play_note_sound)
	

func load_battle_chord_system(chords):
	setup_button()
	set_up_staff(chords)
	get_chords(chords)
	spawn_notes()
	update_note_hand_positions()
	spawn_note_labels()
	staff.align_label(labels)
	


func setup_button():
	$Control/SubmitChords.visible = true
	
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	$Control/SubmitChords.position.x = center_screen_x * 2  - center_screen_x / 10 - $Control/SubmitChords.pivot_offset.x 
	$Control/SubmitChords.position.y = Globals.center_screen_y + Globals.center_screen_y / 1.5  - $Control/SubmitChords.pivot_offset.y
	
	for button in $Control.get_children():
		if button is TexturedButton:
			button.button_scale = Globals.card_scale_factor
			button.scale = Vector2(button.button_scale, button.button_scale)
	

func set_up_staff(segments):
	
	
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
			note.type = "natural"
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
	var chord_check = []
	
	
	var played_notes = []
	for measure in staff.lines:
		for line in measure:
			for note in line.notes_being_held:
				played_notes.append(note.get_note_name_with_type())
	print(played_notes)
	for chord in range(len(target_chords)):
		print(target_chords[chord])
		var remaining_notes = target_chords[chord].duplicate(true)
		var swapped_notes =  $ChordManager.swap_flats_and_sharps(target_chords[chord].duplicate(true))
		for note in played_notes:
			if note in remaining_notes:
				remaining_notes.erase(note)
			elif note in swapped_notes:
				var artificial_array = [note]
				var swapped_note = $ChordManager.swap_flats_and_sharps(artificial_array)
				remaining_notes.erase(swapped_note[0])
		if remaining_notes.size() == 0:
			chord_check.append(true)
	
	if chord_check.size() == target_chords.size():
		are_chords_true = true
	print(chord_check)
	
	last_chord_check = are_chords_true
	
	var current_notes = staff.get_notes_from_current_chords()
	var current_chords = []
	for note in range(current_notes.size()):
		current_chords.append([])
		for n in current_notes[note]:
			current_chords[note].append(n.get_note_name_with_type())
			
		display_if_chord_was_correct(current_chords[note], note)
		await play_chord_sound(current_notes[note])
	
	
	chord_checked.emit()

func spawn_note_labels():
	for chord in len(target_chords):
		var new_chord_label = RichTextLabel.new()
		new_chord_label.bbcode_enabled = true
		
		var chord_text: String
		
		if SaveManager.save_file_data.world_difficulty == 1:
			chord_text = $ChordManager.get_chord_name(target_chords[chord])  + "[br]" + $ChordManager.get_string_chord_notes(target_chords[chord])
		elif SaveManager.save_file_data.world_difficulty == 2:
			if $ChordManager.identify_chord_type(target_chords[chord]) in ["major", "minor"]:
				chord_text = $ChordManager.get_chord_name(target_chords[chord])
			else:
				chord_text = $ChordManager.get_chord_name(target_chords[chord]) + "[br]" + $ChordManager.get_string_chord_notes(target_chords[chord])
		elif SaveManager.save_file_data.world_difficulty == 3:
			chord_text = $ChordManager.get_chord_name(target_chords[chord])
		else:
			chord_text = $ChordManager.get_chord_name(target_chords[chord])
		
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
		
		
		
		
		new_chord_label.name = $ChordManager.get_chord_name(target_chords[chord]) + "ChordLabel"
		
		
		
		labels.append(new_chord_label)
		
func display_if_chord_was_correct(chord_to_check, current_index):
	var sorted_chord_to_check = []
	for note in chord_to_check:
		if "b" in note:
			sorted_chord_to_check.append(ChordManager.swap_note_flats_and_sharps(note))
		else:
			sorted_chord_to_check.append(note)
			
	sorted_chord_to_check.sort()
	
	
	var chord_is_true: bool = false
	
	for chord in range(len(target_chords)):
		var sorted_target_chord = []
		for note in target_chords[chord]:
			if "b" in note:
				sorted_target_chord.append(ChordManager.swap_note_flats_and_sharps(note))
			else:
				sorted_target_chord.append(note)
		
		sorted_target_chord.sort()
		
		if sorted_target_chord == sorted_chord_to_check:
			chord_is_true = true
		
	var chord_text = labels[current_index].get_parsed_text()
	var text_color = "red"
	if chord_is_true:
		text_color = "green"
	labels[current_index].text = "[color=%s][font_size=%d]%s[/font_size][/color]" % [text_color, text_size, chord_text]

func play_note_sound(note):
	var pitch = note.pitch
	var sound_note_name = note.get_note_name_with_type()
	
	if note.type == "flat":
		if note.note == "C":
			pitch = str(int(note.pitch) - 1)
		sound_note_name = %ChordManager.swap_note_flats_and_sharps(sound_note_name)
	elif note.type == "sharp":
		if note.note == "B":
			pitch = str(int(note.pitch) + 1)
	SoundManager.play_note(sound_note_name, pitch)


func play_chord_sound(chord):
	var pitches: Array
	var note_names: Array
	for note in chord:
		var pitch = note.pitch
		var sound_note_name = note.get_note_name_with_type()
		
		if note.type == "flat":
			if note.note == "C":
				pitch = str(int(note.pitch) - 1)
			sound_note_name = %ChordManager.swap_note_flats_and_sharps(sound_note_name)
		elif note.type == "sharp":
			if note.note == "B":
				pitch = str(int(note.pitch) + 1)
			
		pitches.append(pitch)
		note_names.append(sound_note_name)
	await SoundManager.play_chord(note_names,pitches)









	
