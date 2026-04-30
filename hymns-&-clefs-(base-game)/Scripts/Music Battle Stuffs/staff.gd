extends Node2D
# constants used to instanciate parts of the staff
const STAFF_LINE_REFERENCE = preload("uid://l7qvyru1rdq6") #"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff_line.tscn"
const MEASURE_VER_LINE_REFERENCE = preload("uid://rahc3qlfgf7x") #"res://Scenes/Music Battle System Stuffs/Staff Stuff/measure_vertical_lines.tscn"
const END_MEASURE_VER_LINE_REFERENCE = preload("uid://bktwnnt44k6br")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/end_measure_vertical_lines.tscn"

# constants used for logic, game loop, checks, and Sound.
const G_CLEF_NOTES = ["G","F","E","D","C","B","A","G","F","E","D"]
const G_CLEF_PITCH = ["5","5","5","5","5","4","4","4","4","4","4"]
const F_CLEF_NOTES = ["B","A","G","F","E","D","C","B","A","G","F"]
const F_CLEF_PITCH = ["4","4","4","4","4","4","4","3","3","3","3"]

#constants used for sizing
const MEASURE_WIDTH_SEGMENTS = 18
const CLEFF_START_SEGMENTS = 10
const END_LINE_END_SEGMENTS = 2


# loads constant into variable useful for chord checker logic 
#(only needs to check one as only one clef can be selected per savefile)
var clef: Array
var pitches: Array

#variables for staff spawning
var lines: Array = []
var measure_separators: Array= []
var measure_segments : int
var vertical_spacing: float

#What chords are there in the staff right now
var current_chords:Array = []


func load_staff(segments):
	load_clef_from_memory()
	
	measure_segments = segments
	
	spawn_measures()
	set_spacing_variables()
	
	order_lines()
	spawn_measure_separators()
	order_measure_separators()
	spawn_and_order_end_line()
	
	order_icons()
	assign_notes_to_lines()


func load_clef_from_memory():
	if SaveManager.save_file_data.cleff_type == 0:
		clef = G_CLEF_NOTES
		pitches = G_CLEF_PITCH
		$TrebleClef.visible = true
		$BassClef.visible = false
	elif SaveManager.save_file_data.cleff_type == 1:
		clef = F_CLEF_NOTES
		pitches = F_CLEF_PITCH
		$TrebleClef.visible = false
		$BassClef.visible = true
	else:
		clef = G_CLEF_NOTES
		pitches = G_CLEF_PITCH
		$TrebleClef.visible = true
		$BassClef.visible = false


func set_spacing_variables():
	vertical_spacing = lines[-1][-1].get_node("mid_line_texture").texture.get_height() * 2
	#print(vertical_spacing)

func spawn_measures():

	
	var line_width
	for n in range(measure_segments):
		if measure_segments == 1:
			line_width = MEASURE_WIDTH_SEGMENTS + END_LINE_END_SEGMENTS + CLEFF_START_SEGMENTS
		else:
			if n == 0:
				line_width = MEASURE_WIDTH_SEGMENTS + CLEFF_START_SEGMENTS
			elif n == measure_segments - 1:
				line_width = MEASURE_WIDTH_SEGMENTS + END_LINE_END_SEGMENTS
			else:
				line_width = MEASURE_WIDTH_SEGMENTS
		spawn_lines(line_width)

func spawn_lines(line_width):
	lines.append(Array())
	for n in range(5+6): # lines + spaces = 11
		spawn_line(line_width)

func spawn_line(line_width):
	var new_line = STAFF_LINE_REFERENCE.instantiate()
	new_line.transform_line_to_lenght(line_width)
	$line_manager.add_child(new_line)
	lines[-1].append(new_line)

func order_lines():
	var total_lenght = 0
	for s in lines:
		total_lenght += s[-1].get_line_lenght()

	var start_lenght_position = -total_lenght/2.0
	var x_offset = 0
	
	for s in range(len(lines)):
		var measure = lines[s]
		var measure_width = measure[-1].get_line_lenght()
		var middle_index = (len(lines[s]) - 1) / 2.0

		for n in range(len(lines[s])):
			measure[n].position.x = start_lenght_position + x_offset + measure_width/2.0
			measure[n].position.y = (n - middle_index) * vertical_spacing
			
			if n % 2 == 0:
				var line = measure[n]
				line.get_node("mid_line_texture").visible = false
				line.get_node("end_line_texture_left").visible = false
				line.get_node("end_line_texture_right").visible = false
		x_offset += measure_width


func spawn_measure_separators():
	var line_height = 15 #15 line heights from top line to bottom line (exclusive)
	for n in range(measure_segments):
		var new_line = MEASURE_VER_LINE_REFERENCE.instantiate()
		new_line.transform_line_to_lenght(line_height)
		$".".add_child(new_line)
		measure_separators.append(new_line)

func order_measure_separators():
	var middle_height_index = (len(lines[-1]) - 1) / 2.0
	var m = measure_separators
	for n in range(len(lines)):
		m[n].position.x = lines[n][middle_height_index].position.x - lines[n][middle_height_index].get_line_lenght() / 2.0 + m[n].get_node("mid_line_texture").texture.get_width()/2

func spawn_and_order_end_line():
	var line_height = 15 #15 line heights from top line to bottom line (exclusive)
	var middle_height_index = (len(lines[-1]) - 1) / 2.0
	var new_line = END_MEASURE_VER_LINE_REFERENCE.instantiate()
	new_line.transform_line_to_lenght(line_height)
	$".".add_child(new_line)
	measure_separators.append(new_line)
	new_line.position.x = lines[-1][middle_height_index].position.x + lines[-1][middle_height_index].get_line_lenght() / 2.0 - new_line.get_node("mid_line_texture").texture.get_width()/2


func order_icons():
	var middle_height_index = (len(lines[-1]) - 1) / 2.
	var clef_position = lines[0][middle_height_index].position.x - (lines[0][middle_height_index].get_line_lenght() / 4.0)
	
	$TrebleClef.position.y = lines[0][middle_height_index].position.y
	$TrebleClef.position.x = clef_position
	$BassClef.position.y = lines[0][middle_height_index].position.y
	$BassClef.position.x = clef_position
	


func assign_notes_to_lines():
	for s in range(len(lines)):
		for n in range(len(lines[s])):
			lines[s][n].line_defined_note = clef[n]
			lines[s][n].line_defined_pitch = pitches[n]
	
	#for s in lines:
		#for n in s:
			#print(n.line_defined_note)
			
			

func align_notes():
	var start_line_offset = CLEFF_START_SEGMENTS*lines[0][0].get_node("mid_line_texture").texture.get_width()
	var end_line_offset = END_LINE_END_SEGMENTS*lines[0][0].get_node("mid_line_texture").texture.get_width()
	
	for measure in range(len(lines)):
		#print("measure: ", measure)
		for line in range(len(lines[measure])):
			#print("line: ", line)
			for note in lines[measure][line].notes_being_held:
				#print("note: ", note)
				var line_ref = lines[measure][line]
				if lines.size() == 1:
					note.global_position.x = line_ref.global_position.x + start_line_offset - end_line_offset
					note.global_position.y = line_ref.global_position.y
				else:
					if measure == 0:
						note.global_position.x = line_ref.global_position.x + start_line_offset
						note.global_position.y = line_ref.global_position.y
					elif measure == len(lines)-1:
						note.global_position.x = line_ref.global_position.x - end_line_offset
						note.global_position.y = line_ref.global_position.y
					else:
						note.global_position.x = line_ref.global_position.x
						note.global_position.y = line_ref.global_position.y


func align_label(labels):
	var start_line_offset = CLEFF_START_SEGMENTS*lines[0][0].get_node("mid_line_texture").texture.get_width()
	var end_line_offset = END_LINE_END_SEGMENTS*lines[0][0].get_node("mid_line_texture").texture.get_width()
	var fixed_y_position = Globals.center_screen_y / 4
	
	
	
	for measure in range(len(lines)):
		if lines.size() == 1:
			labels[measure].global_position.x = lines[measure][0].global_position.x + start_line_offset - end_line_offset - (labels[measure].size.x * labels[measure].scale.x) / 2.0
			labels[measure].global_position.y = fixed_y_position
		else:
			if measure == 0:
				labels[measure].global_position.x = lines[measure][0].global_position.x + start_line_offset - (labels[measure].size.x * labels[measure].scale.x) / 2.0
				labels[measure].global_position.y = fixed_y_position
			elif measure == len(lines)-1:
				labels[measure].global_position.x = lines[measure][0].global_position.x - end_line_offset - (labels[measure].size.x * labels[measure].scale.x) / 2.0
				labels[measure].global_position.y = fixed_y_position
			else:
				labels[measure].global_position.x = lines[measure][0].global_position.x - (labels[measure].size.x * labels[measure].scale.x) / 2.0
				labels[measure].global_position.y = fixed_y_position


func get_notes_from_current_chords():
	current_chords.clear()
	for measure in lines:
		var chords = []
		for line in measure:
			for note in line.notes_being_held:
				chords.append(note)
		current_chords.append(chords)
	return current_chords
