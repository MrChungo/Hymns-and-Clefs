extends Node
class_name SoundManagerClass ## This class manages sound playing in the game.

const FLUTE_NOTES_PATH = preload("uid://civcgmid4g4fj") #"res://Scenes/MusicPlayer/flute_single_notes.tscn"
const CELLO_NOTES_PATH = preload("uid://k0rbllmkhdd1") #"res://Scenes/MusicPlayer/cello_single_notes.tscn"
var chosen_instrument: String

var instrument_sounds: Node


## This method loads sounds depending on what clef is selected on [SaveManagerClass.save_file_data.cleff_type]
func load_from_savefile():
	for child in get_children():
		child.queue_free()
	
	if SaveManager.save_file_data.cleff_type == 0:
		load_instrument("flute")
	elif SaveManager.save_file_data.cleff_type == 1:
		load_instrument("cello")
	else:
		load_instrument("flute")

## This method loads the sound of an instrument based on [param stinstrument_namering]
func load_instrument(instrument_name:String):
	chosen_instrument = instrument_name
	if chosen_instrument == "flute":
		instrument_sounds = FLUTE_NOTES_PATH.instantiate()
		$".".add_child(instrument_sounds)
	elif chosen_instrument == "cello":
		instrument_sounds = CELLO_NOTES_PATH.instantiate()
		$".".add_child(instrument_sounds)

# This method plays the sound of a note.
func play_note(note, pitch, wait = false):
		
	var node_name = note + pitch + " " + chosen_instrument
	# Store the specific note node in a variable
	var note_node = instrument_sounds.get_node(node_name)
	
	note_node.play()
	
	if wait:
		# Await the signal from the SPECIFIC note that is playing
		#print("Finished playing: ", node_name)
		await note_node.finished 
		

## This method plays the sound of a chord.
func play_chord(notes: Array, pitches: Array):
	for n in range(len(notes)):
		if n != len(notes) -1:
			play_note(notes[n], pitches[n])
		else:
			await play_note(notes[n], pitches[n],true)
	
