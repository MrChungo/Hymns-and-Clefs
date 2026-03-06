extends Node
'''
https://www.musictheory.net/lessons/40
https://en.wikipedia.org/wiki/Chord_(music)
'''

const NOTES_WITH_SHARPS = ["A","A#","B","C","C#","D","D#","E","F","F#","G","G#"]

const NOTES_WITH_FLATS = ["A","Bb","B","C","Db","D","Eb","E","F","Gb","G","Ab"]

var global_rarities = load("uid://dxut7bry6abc") #RANDOM_REFERENCE.get_weighted_rarity()

#func _ready() -> void:
#	SaveManager._load()
#	print(gen_chord())


func gen_chord():
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
		if third + root + 4 <= len(scale):
			third = root + 4
		else:
			third = root + 4 - 12
		
		#gets a perfect fifth
		if fifth + root + 7 <= len(scale):
			fifth = root + 7
		else:
			fifth = root + 7 - 12
		
		
	elif chord_type == "minor":
		#gets a minor third
		if third + root + 3 <= len(scale):
			third = root + 3
		else:
			third = root + 3 - 12
		
		#gets a perfect fifth
		if fifth + root + 7 <= len(scale):
			fifth = root + 7
		else:
			fifth = root + 7 - 12
			
	elif chord_type == "augmented":
		#gets a major third
		if third + root + 4 <= len(scale):
			third = root + 4
		else:
			third = root + 4 - 12
		
		#gets a augmented fifth
		if fifth + root + 8 <= len(scale):
			fifth = root + 8
		else:
			fifth = root + 8 - 12
	elif chord_type == "diminished":
		#gets a minor third
		if third + root + 3 <= len(scale):
			third = root + 3
		else:
			third = root + 3 - 12
		
		#gets a diminished fifth
		if fifth + root + 6 <= len(scale):
			fifth = root + 6
		else:
			fifth = root + 6 - 12
	
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
	return Random.get_random_int(0,len(scale))

func get_chord_type():
	return Random.get_weighted_rarity_by_world(global_rarities.chord_type_rarity)

	
	
	
	
	
	
	
