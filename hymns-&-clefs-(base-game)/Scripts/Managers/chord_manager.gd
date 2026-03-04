extends Node
'''
https://www.musictheory.net/lessons/40
https://en.wikipedia.org/wiki/Chord_(music)
'''
const NOTES_WITH_SHARPS = ["A","A#","B","C","C#","D","D#","E","F","F#","G","G#"]

const NOTES_WITH_FLATS = ["A","Bb","B","C","Db","D","Eb","E","F","Gb","G","Ab"]


func gen_chord():
	var chord: Array
	var scale: Array
	var chord_type: String
	var root: int
	var third: int
	var fifth: int
	'''

	7th?
	'''
	if chord_type == "major":
		third = root + 4
		fifth = root + 7
	elif chord_type == "minor":
		third = root + 3
		fifth = root + 7
	elif chord_type == "augmented":
		third = root + 4
		fifth = root + 8
	elif chord_type == "diminished":
		third = root + 3
		fifth = root + 6
	
	chord.append(scale[root])
	chord.append(scale[third])
	chord.append(scale[fifth])
		

	return chord
