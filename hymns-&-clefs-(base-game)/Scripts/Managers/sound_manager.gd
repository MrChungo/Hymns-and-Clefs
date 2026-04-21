extends Node

const FLUTE_NOTES_PATH = preload("uid://civcgmid4g4fj") #"res://Scenes/MusicPlayer/flute_single_notes.tscn"

var instrument: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_instrument("flute")
	play_note("A#","4")
	play_note("D","5")
	play_note("F","5")
	 


func load_instrument(string):
	instrument = string
	if string == "flute":
		var instrument_sounds = FLUTE_NOTES_PATH.instantiate()
		$".".add_child(instrument_sounds)

func play_note(note, pitch):
	var node_name = note + pitch + " " + instrument
	$FluteSingleNotes.get_node(node_name).play()
