extends Node
class_name ChordManagerClass

'''
https://www.musictheory.net/lessons/40
https://en.wikipedia.org/wiki/Chord_(music)
'''

const NOTES_WITH_SHARPS:Array = ["A","A#","B","C","C#","D","D#","E","F","F#","G","G#"] ## Chromatic scale with sharps
const NOTES_WITH_FLATS:Array = ["A","Bb","B","C","Db","D","Eb","E","F","Gb","G","Ab"] ## Chromatic scale with flats

var global_rarities = load("uid://dsdqu3nm2dwxg") #RANDOM_REFERENCE.get_weighted_rarity()


## This method generates an [Array] that contains the notes of a chord [br]:
## These notes are in the format [root, third, fifth]. And it's possible chord [br]
## options are: MAJOR, MINOR, AUGMENTED, DIMINISHED. 
func gen_chord() -> Array:
	var chord: Array
	var chord_type = get_chord_type()
	var scale = get_scale(chord_type)
	var root = get_random_index_from_scale(scale)
	var third: int
	var fifth: int
	'''
	are we gonna do 7ths?
	'''
	if chord_type == "major":
		#gets a major third
		if third + root + 4 < len(scale):
			third = root + 4
		else:
			third = root + 4 - 12
		
		#gets a perfect fifth
		if fifth + root + 7 < len(scale):
			fifth = root + 7
		else:
			fifth = root + 7 - 12
		
		
	elif chord_type == "minor":
		#gets a minor third
		if third + root + 3 < len(scale):
			third = root + 3
		else:
			third = root + 3 - 12
		
		#gets a perfect fifth
		if fifth + root + 7 < len(scale):
			fifth = root + 7
		else:
			fifth = root + 7 - 12
			
	elif chord_type == "augmented":
		#gets a major third
		if third + root + 4 < len(scale):
			third = root + 4
		else:
			third = root + 4 - 12
		
		#gets a augmented fifth
		if fifth + root + 8 < len(scale):
			fifth = root + 8
		else:
			fifth = root + 8 - 12
	elif chord_type == "diminished":
		#gets a minor third
		if third + root + 3 < len(scale):
			third = root + 3
		else:
			third = root + 3 - 12
		
		#gets a diminished fifth
		if fifth + root + 6 < len(scale):
			fifth = root + 6
		else:
			fifth = root + 6 - 12
			
	#print(root, " ", third, " ", fifth)
	chord.append(scale[root])
	chord.append(scale[third])
	chord.append(scale[fifth])
	
	return chord
	
## This method returns a scale with either sharps or flats, deppending on [br]
## a chord type.
func get_scale(chord_type:String) -> Array:
	if chord_type == "major":
		return NOTES_WITH_SHARPS
	elif chord_type == "minor":
		return NOTES_WITH_FLATS
	elif chord_type == "augmented":
		return NOTES_WITH_SHARPS
	elif chord_type == "diminished":
		return NOTES_WITH_FLATS
	else:
		return NOTES_WITH_SHARPS
	
	
## THis method returns a random index from within [constant NOTES_WITH_SHARPS], or [constant NOTES_WITH_FLATS]
func get_random_index_from_scale(scale:Array):
	return Random.get_random_int(0,len(scale)-1)

##This function gets a random chord type using the method [RandomClass.get_weighted_rarity_by_world].
func get_chord_type():
	return Random.get_weighted_rarity_by_world(global_rarities.chord_type_rarity)
	
## This method identifies the type of chord that is inserted as it's parameter.
func identify_chord_type(chord) -> String:
	var chord_type: String
	var chord_scale_index = get_chord_scale_index(chord)
	var third = ""
	var fifth = ""
	
	#checking if major third
	if chord_scale_index[1] - chord_scale_index[0] == 4 or chord_scale_index[1] + 12 - chord_scale_index[0] == 4:
		third = "major"
	elif chord_scale_index[1] - chord_scale_index[0] == 3 or chord_scale_index[1] + 12 - chord_scale_index[0] == 3:
		third = "minor"
	else:
		third = "error"
	
	
	
	if chord_scale_index[2] - chord_scale_index[0] == 7 or chord_scale_index[2] - chord_scale_index[0] == 7 - 12:
		fifth = "perfect"
	elif chord_scale_index[2] - chord_scale_index[0] == 8 or chord_scale_index[2] - chord_scale_index[0] == 8 - 12:
		fifth = "augmented"
	elif chord_scale_index[2] - chord_scale_index[0] == 6 or chord_scale_index[2] - chord_scale_index[0] == 6 - 12:
		fifth = "diminished"
	else:
		fifth = "error"

	
	if third == "major" and fifth == "perfect":
		chord_type = "major"
	elif third == "minor" and fifth == "perfect":
		chord_type = "minor"
	elif third == "major" and fifth == "augmented":
		chord_type = "augmented"
	elif third == "minor" and fifth == "diminished":
		chord_type = "diminished"
	else:
		return "ERROR"
	return chord_type

## THis method gets the name of a chord from an [Array] with 3 notes.
func get_chord_name(chord:Array) -> String:
	var chord_name: String
	var chord_scale_index = get_chord_scale_index(chord)
	var third = ""
	var fifth = ""
	
	#checking if major third
	if chord_scale_index[1] - chord_scale_index[0] == 4 or chord_scale_index[1] + 12 - chord_scale_index[0] == 4:
		third = "major"
	elif chord_scale_index[1] - chord_scale_index[0] == 3 or chord_scale_index[1] + 12 - chord_scale_index[0] == 3:
		third = "minor"
	else:
		third = "error"
	
	
	
	if chord_scale_index[2] - chord_scale_index[0] == 7 or chord_scale_index[2] - chord_scale_index[0] == 7 - 12:
		fifth = "perfect"
	elif chord_scale_index[2] - chord_scale_index[0] == 8 or chord_scale_index[2] - chord_scale_index[0] == 8 - 12:
		fifth = "augmented"
	elif chord_scale_index[2] - chord_scale_index[0] == 6 or chord_scale_index[2] - chord_scale_index[0] == 6 - 12:
		fifth = "diminished"
	else:
		fifth = "error"

	
	if third == "major" and fifth == "perfect":
		chord_name = chord[0]
	elif third == "minor" and fifth == "perfect":
		chord_name = chord[0] + "m"
	elif third == "major" and fifth == "augmented":
		chord_name = chord[0] + "aug"
	elif third == "minor" and fifth == "diminished":
		chord_name = chord[0] + "dim"
	else:
		return "ERROR"
	return chord_name

## This method returns the notes from a chord [Array], as a [String]
func get_string_chord_notes(chord) -> String:
	var chord_name = ""
	for n in range(len(chord)):
		if n != len(chord)-1:
			chord_name += chord[n] + " "
		else:
			chord_name += chord[n]
	return chord_name

## This method returns the index position of a note within either [constant NOTES_WITH_SHARPS], [br]
## or [constant NOTES_WITH_FLATS]
func get_chord_scale_index(chord:Array) -> Array:
	var chord_scale_indexes: Array
	var scale = find_scale_from_chord(chord)
	
	for note in chord:
		for n in range(len(scale)):
			if note == scale[n]:
				chord_scale_indexes.append(n)
	

	return chord_scale_indexes
	
## This method checks if a chord [Array] is a part of either [constant NOTES_WITH_SHARPS], or [constant NOTES_WITH_FLATS]
func find_scale_from_chord(chord):
	for note in chord:
		if "#" in note:
			return NOTES_WITH_SHARPS
		if "b" in note:
			return NOTES_WITH_FLATS
	return NOTES_WITH_SHARPS

## This function gets the correct name of a note (eg: B# -> C)
func get_correct_note_name(wrong_name:String) -> String:
	var scale = find_scale_from_chord([wrong_name])
	var base_note_index = get_chord_scale_index([wrong_name[0]])[0]
	var right_name
	
	if "#" in wrong_name:
		if scale == NOTES_WITH_SHARPS:
			if base_note_index + 1 < len(NOTES_WITH_SHARPS): 
				right_name = NOTES_WITH_SHARPS[base_note_index + 1]
			else:
				right_name = NOTES_WITH_SHARPS[base_note_index + 1 - 12]
	elif "b" in wrong_name:
		if scale == NOTES_WITH_FLATS:
			if base_note_index - 1 > 0: 
				right_name = NOTES_WITH_FLATS[base_note_index - 1]
			else:
				right_name = NOTES_WITH_FLATS[base_note_index - 1 + 12]
	else:
		right_name = wrong_name
	
	return right_name

## This method swaps the notes within a chord [Array] from Sharps to Flats.
func swap_flats_and_sharps(chord: Array) -> Array:
	var new_chord: Array
	if find_scale_from_chord(chord) == NOTES_WITH_SHARPS:
		for index in get_chord_scale_index(chord).duplicate(true):
			new_chord.append(NOTES_WITH_FLATS[index])
	else:
		for index in get_chord_scale_index(chord).duplicate(true):
			new_chord.append(NOTES_WITH_SHARPS[index])
	return new_chord

## This method swaps a note name from Sharp to Flat..
func swap_note_flats_and_sharps(note: String) -> String:
	var new_note: String
	if find_scale_from_chord([note]) == NOTES_WITH_SHARPS:
		for index in get_chord_scale_index([note]).duplicate(true):
			new_note = NOTES_WITH_FLATS[index]
	else:
		for index in get_chord_scale_index([note]).duplicate(true):
			new_note = NOTES_WITH_SHARPS[index]
	return new_note














	
