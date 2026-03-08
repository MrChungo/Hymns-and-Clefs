extends Node
'''
https://www.musictheory.net/lessons/40
https://en.wikipedia.org/wiki/Chord_(music)
'''

const NOTES_WITH_SHARPS = ["A","A#","B","C","C#","D","D#","E","F","F#","G","G#"]
const NOTES_WITH_FLATS = ["A","Bb","B","C","Db","D","Eb","E","F","Gb","G","Ab"]

var global_rarities = load("uid://dxut7bry6abc") #RANDOM_REFERENCE.get_weighted_rarity()

#func _ready() -> void:
	#SaveManager._load()
	#SaveManager.save_file_data.world_difficulty = 2
	#var trials = 10
	#for n in range(trials):
		#var chord = gen_chord()
		#print(chord)
		#print(get_chord_name(chord))


func gen_chord() -> Array:
	var chord: Array
	var scale = get_scale()
	var chord_type = get_chord_type()
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
			
	print(root, " ", third, " ", fifth)
	chord.append(scale[root])
	chord.append(scale[third])
	chord.append(scale[fifth])
	
	return chord
	
	
func get_scale():
	var scale_chosen = Random.get_random_int(0,1)
	if scale_chosen == 0:
		return NOTES_WITH_SHARPS
	elif scale_chosen == 1:
		return NOTES_WITH_FLATS

func get_random_index_from_scale(scale):
	return Random.get_random_int(0,len(scale)-1)

func get_chord_type():
	return Random.get_weighted_rarity_by_world(global_rarities.chord_type_rarity)
	
	
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

	#print(third)
	#print(fifth)
	
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


func get_chord_scale_index(chord:Array) -> Array:
	var chord_scale_indexes: Array
	var scale = find_scale_from_chord(chord)
	
	for note in chord:
		for n in range(len(scale)):
			if note == scale[n]:
				chord_scale_indexes.append(n)
	

	return chord_scale_indexes
	
	
func find_scale_from_chord(chord):
	for note in chord:
		if "#" in note:
			return NOTES_WITH_SHARPS
		if "b" in note:
			return NOTES_WITH_FLATS
	return NOTES_WITH_SHARPS
	
