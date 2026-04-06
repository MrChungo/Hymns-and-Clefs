extends Node2D


const NOTE_SCENE = preload("uid://21biyctn0unu")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/note.tscn"
const STAFF_SCENE = preload("uid://cavmm10t43b7r")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff.tscn"

var staff
var target_chords = []
var notes = []
@onready var overall_scale = Globals.center_screen_x/280
@onready var note_y_position = Globals.center_screen_y + Globals.center_screen_y / 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	load_battle_chord_system(2)

func load_battle_chord_system(chords):
	set_up_staff(chords)
	get_chords(chords)
	spawn_notes()
	update_note_positions(0.1)

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
	print(target_chords)
	

func spawn_notes():
	for chord in target_chords:
		for note in chord:
			note = NOTE_SCENE.instantiate()
			note.position.x = Globals.center_screen_x
			note.position.y = Globals.center_screen_y + Globals.center_screen_y/4
			note.scale = Vector2(overall_scale,overall_scale)
			$NoteManager.add_child(note)
			notes.append(note)
	
func update_note_positions(speed):
	for i in range(notes.size()):
		#get new card position based on index
		var new_position = Vector2(calculate_note_position(i), note_y_position)
		var note = notes[i]
		note.position_in_hand = new_position
		animate_note_to_position(note, new_position, speed)

func calculate_note_position(index):
	var note_width =  notes[-1].get_node("Sprite2D").texture.get_width()*overall_scale
	var total_width = note_width * notes.size()
	
	var x_offset = Globals.center_screen_x + (index * note_width) - (total_width / 2.0)
	return x_offset

@warning_ignore("unused_parameter")
func animate_note_to_position(note, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(note, "position", new_position, 0.1)








	
