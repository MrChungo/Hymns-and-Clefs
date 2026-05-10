extends Node2D
class_name BattleChordSystemClass

signal chord_checked ##Signal for when chords within the staff are checked.

const DEFAULT_CARD_MOVE_SPEED:float = 0.1
const NOTE_SCENE = preload("uid://21biyctn0unu")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/note.tscn"
const STAFF_SCENE = preload("uid://cavmm10t43b7r")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff.tscn"


var staff: StaffClass ## [StaffClass] Object
var target_chords:Array = [] ## Chords that will be checked with whatever is inside [member staff].
var notes:Array[NoteClass] = [] ## All notes spawned
var labels:Array = [] ## All chord Text labels (Index 0 = measure 0)
var text_size:int = round(Globals.center_screen_x / 15) ## Scaled text size.

## Scale of [BattleChordSystemClass], this connects the pixel perfect setup of [staff]
##, and all the notes to the screen size.
@onready var overall_scale = Globals.center_screen_x/280 
@onready var note_y_position = Globals.center_screen_y + Globals.center_screen_y / 1.25 ## Where the note "hand" is positioned.

var last_chord_check = false ## Used for [BattleManager] logic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	
## THis method loads and connects all external signals to make the system work. [br]
## These are attatched to [NoteManagerClass], and [InputManagerClass].
func connect_signals() -> void:
	$NoteManager.note_used.connect(update_staff)
	$NoteManager.remove_from_old_array.connect(remove_note_from_line)
	$NoteManager.add_note_to_hand.connect(add_note_to_hand)
	$NoteManager.play_note_sound.connect(play_note_sound)
	$"../InputManager".play_note_sound.connect(play_note_sound)

## This method loads and sets up the system for the player to use. [br]
## This includes, setting up the buttons, loading up the staff, getting the chords [br]
## that the player will try to submit, amd spawn all notes and labels.
func load_battle_chord_system(chord_quantity:int) -> void:
	setup_button()
	set_up_staff(chord_quantity)
	get_chords(chord_quantity)
	spawn_notes()
	update_note_hand_positions()
	spawn_note_labels()
	staff.align_label(labels)
	

## This function gets all buttons to position, and scale.
func setup_button() -> void:
	$Control/SubmitChords.visible = true
	
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	$Control/SubmitChords.position.x = center_screen_x * 2  - center_screen_x / 8 - $Control/SubmitChords.pivot_offset.x 
	$Control/SubmitChords.position.y = Globals.center_screen_y + Globals.center_screen_y / 1.5  - $Control/SubmitChords.pivot_offset.y
	
	for button in $Control.get_children():
		if button is TexturedButton:
			button.button_scale = Globals.card_scale_factor
			button.scale = Vector2(button.button_scale, button.button_scale)
	

## This function spawns a [StaffClass], and sets it's position and scale up.
func set_up_staff(segments:int) -> void:

	staff = STAFF_SCENE.instantiate()
	staff.load_staff(segments)
	staff.position.x = Globals.center_screen_x
	staff.position.y = Globals.center_screen_y + Globals.center_screen_y/4
	staff.scale = Vector2(overall_scale,overall_scale)
	$".".add_child(staff)

## Takes a [param chord_quantity], and spawns chords from [ChordManager] into [br]
## [member target_chords]
func get_chords(chord_quantity:int) -> void:
	for n in range(chord_quantity):
		target_chords.append($ChordManager.gen_chord())

## This method creates a note for every note in every chord of [member target_chords] [br].
## Then adds this note to the note hand, and appends the note to [member notes].
func spawn_notes() -> void:
	for chord in target_chords:
		for note in chord:
			note = NOTE_SCENE.instantiate()
			note.type = "natural"
			note.position.x = Globals.center_screen_x
			note.position.y = Globals.center_screen_y + Globals.center_screen_y/4
			note.scale = Vector2(overall_scale,overall_scale)
			$NoteManager.add_child(note)
			notes.append(note)

## This method updates the position of the notes in hand. (used for when a note [br]
## is moved away or into the hand).
func update_note_hand_positions() -> void:
	for i in range(notes.size()):
		#get new card position based on index
		var new_position = Vector2(calculate_note_hand_position(i), note_y_position)
		var note:NoteClass = notes[i]
		note.position_in_hand = new_position
		animate_note_to_position(note, new_position)

## This method calculates the position of a note and returns the offset that notes should [br]
## be in, on the hand.
func calculate_note_hand_position(index:int) -> float:
	var note_width =  notes[-1].get_node("NoteSprite").texture.get_width()*overall_scale
	var total_width = note_width * notes.size()
	
	var x_offset = Globals.center_screen_x + (index * note_width) - (total_width / 2.0)
	return x_offset

## This note animates the note towards their position in hand.
func animate_note_to_position(note:NoteClass, new_position:Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(note, "position", new_position, DEFAULT_CARD_MOVE_SPEED)

## This method adds a note into the note hand, and updates the notes position.
func add_note_to_hand(note:NoteClass) -> void:
	if note not in notes:
		notes.insert(0, note)
		update_note_hand_positions()
	else:
		animate_note_to_position(note, note.position_in_hand)

## This method removes a note from the note hand, and updates the positions of [br]
## the notes in hand.
func remove_note_from_hand(note:NoteClass) -> void:
	if note in notes:
		notes.erase(note)
		update_note_hand_positions()


## This note removes a note from a [staffLineClass] within [member staff], and updates [member staff]
func remove_note_from_line(note) -> void:
	for measure in staff.lines:
		for line in measure:
			for line_note in line.notes_being_held:
				if line_note == note:
					line.notes_being_held.erase(note)
	update_staff()

## This function updates the [member staff] by realigning the notes within it.
func update_staff() -> void:
	staff.align_notes()


func _on_submit_chords_pressed() -> void:
	$Control/SubmitChords.disabled = true
	var are_chords_true = false
	var chord_check = []
	
	
	var played_notes = []
	for measure in staff.lines:
		for line in measure:
			for note in line.notes_being_held:
				played_notes.append(note.get_note_name_with_type())
	for chord in range(len(target_chords)):
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
	print(chord_check.size() == target_chords.size())
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
	
	
	emit_signal("chord_checked")

## This function spawns and sets up the labels for the chosen chord on each measure of the [member staff]. [br]
## These labels always have the name of the chord (eg: Am, Edim, C, Bdim), but deppending of [br]
## [member SaveManager.save_file_data.chord_difficulty], it makes it so that the labels display [br]
## different things. What they spawn is explained on [method get_chord_label_text_in_show_all_difficulty], [br]
## [method get_chord_label_text_in_progressive_difficulty], and [method get_chord_label_text_in_show_none_difficulty]. [br]
## Then it locates these labels on top of each staff.
func spawn_note_labels() -> void:
	for chord in len(target_chords):
		var new_chord_label = RichTextLabel.new()
		new_chord_label.bbcode_enabled = true
		
		var chord_text: String
		
		if SaveManager.save_file_data.chord_difficulty == save_resource.chord_label_difficulty.SHOW_ALL:
			chord_text = get_chord_label_text_in_show_all_difficulty(chord)
		elif SaveManager.save_file_data.chord_difficulty == save_resource.chord_label_difficulty.PROGRESSIVE:
			chord_text = get_chord_label_text_in_progressive_difficulty(chord)
		elif SaveManager.save_file_data.chord_difficulty == save_resource.chord_label_difficulty.SHOW_NONE:
			chord_text = get_chord_label_text_in_show_none_difficulty(chord)
			
		
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

## This function returns the text of a label, based on a chord. The text always contains [br]
## the chord's name (ex: Cm, A, Eaug, Gdim), but depending on the [member SaveManager.save_file_data.world_difficulty] [br].
## it will return all notes that compose the chord in [member SaveManager.save_file_data.world_difficulty] = 1, [br]
## only the notes of augmented/diminished chords in  [member SaveManager.save_file_data.world_difficulty] = 2, [br]
## and in [member SaveManager.save_file_data.world_difficulty] = 3, it won't show any of the notes.
func get_chord_label_text_in_progressive_difficulty(chord_index:int) -> String:
	var chord_text: String
	if SaveManager.save_file_data.world_difficulty == 1:
		chord_text = $ChordManager.get_chord_name(target_chords[chord_index])  + "[br]" + $ChordManager.get_string_chord_notes(target_chords[chord_index])
	elif SaveManager.save_file_data.world_difficulty == 2:
		if $ChordManager.identify_chord_type(target_chords[chord_index]) in ["major", "minor"]:
			chord_text = $ChordManager.get_chord_name(target_chords[chord_index])
		else:
			chord_text = $ChordManager.get_chord_name(target_chords[chord_index]) + "[br]" + $ChordManager.get_string_chord_notes(target_chords[chord_index])
	elif SaveManager.save_file_data.world_difficulty == 3:
		chord_text = $ChordManager.get_chord_name(target_chords[chord_index])
	else:
		chord_text = $ChordManager.get_chord_name(target_chords[chord_index])
	return chord_text

## This function returns the text of a label, based on a chord. On this difficulty, all chords [br]
## will display their names(ex: Cm, A, Eaug, Gdim), but also all notes that compose them.
func get_chord_label_text_in_show_all_difficulty(chord):
	return $ChordManager.get_chord_name(target_chords[chord])  + "[br]" + $ChordManager.get_string_chord_notes(target_chords[chord])

## This function returns the text of a label, based on a chord. On this difficulty, all chords [br]
## will display only their names(ex: Cm, A, Eaug, Gdim).
func get_chord_label_text_in_show_none_difficulty(chord):
	return $ChordManager.get_chord_name(target_chords[chord])

## This function changes the colour of each label in [member labels] [br]
## (selected by [param current_index]), depending if the chord within [br]
## it's measure on [member staff] (selected by [param current_index]), [br]
## is the same to the [param chord_to_check]. If it is, the label will turn green [br]
## if it's not the label will turn red.
func display_if_chord_was_correct(chord_to_check:Array, current_index:int) -> void:
	var sorted_chord_to_check:Array = []
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

## This method will play the sound of a [NoteClass] related to it's [member NoteClass.pitch] [br]
## and it's name. It uses [method SoundManager.play_note] for this.
func play_note_sound(note: NoteClass) -> void:
	var pitch:String = note.pitch
	var sound_note_name:String = note.get_note_name_with_type()
	
	#changes all notes to sharps because that's how SoundManager accepts them.
	if note.type == "flat":
		if note.note == "C":
			pitch = str(int(note.pitch) - 1)
		sound_note_name = %ChordManager.swap_note_flats_and_sharps(sound_note_name)
	elif note.type == "sharp":
		if note.note == "B":
			pitch = str(int(note.pitch) + 1)
	SoundManager.play_note(sound_note_name, pitch)


## This method will play the sound of a chord related to the names and pitches [br]
## of the [Noteclass] within it. It uses [method SoundManager.play_chord] for this.
func play_chord_sound(chord:Array) -> void:
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









	
