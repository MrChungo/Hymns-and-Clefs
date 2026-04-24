extends Node

const FLUTE_NOTES_PATH = preload("uid://civcgmid4g4fj") #"res://Scenes/MusicPlayer/flute_single_notes.tscn"
const CELLO_NOTES_PATH = preload("uid://k0rbllmkhdd1") #"res://Scenes/MusicPlayer/cello_single_notes.tscn"
var instrument: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_instrument("flute")



func load_instrument(string):
	instrument = string
	if string == "flute":
		var instrument_sounds = FLUTE_NOTES_PATH.instantiate()
		$".".add_child(instrument_sounds)
	elif string == "cello":
		var instrument_sounds = CELLO_NOTES_PATH.instantiate()
		$".".add_child(instrument_sounds)

func play_note(note, pitch, wait = false):
		
	var node_name = note + pitch + " " + instrument
	# Store the specific note node in a variable
	var note_node = $FluteSingleNotes.get_node(node_name)
	
	note_node.play()
	
	if wait:
		# Await the signal from the SPECIFIC note that is playing
		#print("Finished playing: ", node_name)
		await note_node.finished 
		


func play_chord(notes: Array, pitches: Array):
	for n in range(len(notes)):
		if n != len(notes) -1:
			play_note(notes[n], pitches[n])
		else:
			await play_note(notes[n], pitches[n],true)
	
