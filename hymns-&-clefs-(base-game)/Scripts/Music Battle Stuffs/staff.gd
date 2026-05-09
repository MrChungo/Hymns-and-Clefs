extends Node2D
class_name StaffClass

# constants used to instanciate parts of the staff
const STAFF_LINE_REFERENCE = preload("uid://l7qvyru1rdq6") #"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff_line.tscn"
const MEASURE_VER_LINE_REFERENCE = preload("uid://rahc3qlfgf7x") #"res://Scenes/Music Battle System Stuffs/Staff Stuff/measure_vertical_lines.tscn"
const END_MEASURE_VER_LINE_REFERENCE = preload("uid://bktwnnt44k6br")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/end_measure_vertical_lines.tscn"

# constants used for logic, game loop, checks, and Sound.
## Notes of the staff organized from space above the highest line, to the [br]
## space below the lowest line.
const G_CLEF_NOTES = ["G","F","E","D","C","B","A","G","F","E","D"]
## Pitches of the staff organized from space above the highest line, to the [br]
## space below the lowest line.
const G_CLEF_PITCH = ["5","5","5","5","5","4","4","4","4","4","4"]
## Notes of the staff organized from space above the highest line, to the [br]
## space below the lowest line.
const F_CLEF_NOTES = ["B","A","G","F","E","D","C","B","A","G","F"]
## Pitches of the staff organized from space above the highest line, to the [br]
## space below the lowest line.
const F_CLEF_PITCH = ["4","4","4","4","4","4","4","3","3","3","3"]

#constants used for sizing
const MEASURE_WIDTH_SEGMENTS = 18 ## A "segment" is a middle texture of the "line" node.
const CLEFF_START_SEGMENTS = 10 ## A "segment" is a middle texture of the "line" node.
const END_LINE_END_SEGMENTS = 2 ## A "segment" is a middle texture of the "line" node.
##Line heights from top line to bottom line (exclusive) (measured by pixels) [br]
## default value should be 15. This value is measured like this: there are [br]
## 5 lines on the staff, then there's 4 spaces on the staff (9), then you must count [br]
## the padding spaces within each space and line (which in this case is one line height) [br]
## this makes the amount of line widths from the top line to the bottom line 15
const STAFF_HEIGHT: int = 15


# loads constant into variable useful for chord checker logic 
# (only needs to check one as only one clef can be selected per savefile)
var clef: Array
var pitches: Array

#variables for staff spawning
var lines: Array = [] ## 2d list that simulates how a staff is set up. Rows are measures and Columns are lines/spaces
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

## this function loads from SaveManager savefile data the required [br]
## information and variables needed to set up the staff (mainly the cleff and [br]
## notes/pitches). In addition it also loads the texture for the clef.
func load_clef_from_memory() -> void:
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

## Sets the vertical_spacing variable
func set_spacing_variables() -> void:
	vertical_spacing = lines[-1][-1].get_node("mid_line_texture").texture.get_height() * 2

## Calculates required lenght of lines depending on how many measure segments [br]
## there are on the staff. Then it calls upon [method spawn_lines] to update the list lines [br]
## into a 2d list where the colums are the measures, and the rows are the lines and spaces [br]
## on the staff
func spawn_measures() -> void:

	var line_width:int ##Each unit represents a pixel
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

## This method creates and adds 5 lines and 6 spaces using [method spawn_line] [br]
## into [member lines] simulating the lines and spaces of a staff [br] 
## (without counting ledger lines).
func spawn_lines(line_width) -> void:
	lines.append(Array())
	for n in range(5+6): # lines + spaces = 11
		spawn_line(line_width)

##This method instanciates a line using [constant STAFF_LINE_REFERENCE] as a blueprint [br]
## then adds this line to the last measure created in [member lines]. [br]
## Important to note that it adds the created [Node2D] into a [Node2D] within the staff [br]
## called line_manager for display into the tree.
func spawn_line(line_width) -> void:
	var new_line: Node2D = STAFF_LINE_REFERENCE.instantiate()
	new_line.transform_line_to_lenght(line_width)
	$line_manager.add_child(new_line)
	lines[-1].append(new_line)

## This method organizes all of the spawned horizontal lines into [br]
## a staff.
func order_lines() -> void:
	var total_lenght = 0
	
	#calculates the lenght of the whole staff
	for s in lines:
		total_lenght += s[-1].get_line_lenght()

	var start_lenght_position = -total_lenght/2.0
	var x_offset = 0
	
	#starts organizing lines per measure
	for s in range(len(lines)):
		var measure:Array = lines[s]
		var measure_width = measure[-1].get_line_lenght()
		var middle_index = (len(lines[s]) - 1) / 2.0
		
		#organizes each line within the measure
		for n in range(len(lines[s])):
			measure[n].position.x = start_lenght_position + x_offset + measure_width/2.0
			measure[n].position.y = (n - middle_index) * vertical_spacing
			
			#makes the "spaces" in the staff actually invisible
			#the code recognizes these spaces just as other lines.
			if n % 2 == 0:
				var line:Node2D = measure[n]
				line.get_node("mid_line_texture").visible = false
				line.get_node("end_line_texture_left").visible = false
				line.get_node("end_line_texture_right").visible = false
		x_offset += measure_width

## This method spawns the bar lines (otherwise known as measure separators). [br]
## Important to note that it doesn not spawn the final bar line (otherwise known as [br]
## end line separators). That is handled by [method spawn_and_order_end_line]
func spawn_measure_separators() -> void:
	var line_height: int = STAFF_HEIGHT 
	for n in range(measure_segments):
		var new_line:Node2D = MEASURE_VER_LINE_REFERENCE.instantiate()
		new_line.transform_line_to_lenght(line_height)
		$".".add_child(new_line)
		measure_separators.append(new_line)

## This method orders the measure separators (it moves to then to the begining [br]
## of each measure.
func order_measure_separators() -> void:
	var middle_height_index = (len(lines[-1]) - 1) / 2.0
	var m:Array = measure_separators
	for n in range(len(lines)):
		m[n].position.x = lines[n][middle_height_index].position.x - lines[n][middle_height_index].get_line_lenght() / 2.0 + m[n].get_node("mid_line_texture").texture.get_width()/2

## This function spawns and organizes the final bar line at the end of the staff.
func spawn_and_order_end_line() -> void:
	var line_height: int = STAFF_HEIGHT 
	var middle_height_index = (len(lines[-1]) - 1) / 2.0
	var new_line:Node2D = END_MEASURE_VER_LINE_REFERENCE.instantiate()
	new_line.transform_line_to_lenght(line_height)
	$".".add_child(new_line)
	measure_separators.append(new_line)
	new_line.position.x = lines[-1][middle_height_index].position.x + lines[-1][middle_height_index].get_line_lenght() / 2.0 - new_line.get_node("mid_line_texture").texture.get_width()/2

## This function orders the position of the G and F clefs into place. 
func order_icons() -> void:
	var middle_height_index = (len(lines[-1]) - 1) / 2.
	var clef_position = lines[0][middle_height_index].position.x - (lines[0][middle_height_index].get_line_lenght() / 4.0)
	
	$TrebleClef.position.y = lines[0][middle_height_index].position.y
	$TrebleClef.position.x = clef_position
	$BassClef.position.y = lines[0][middle_height_index].position.y
	$BassClef.position.x = clef_position

## This function asigns all the lines in a measure their respective notes, and pitches. [br]
## This is dependent on the cleff chosen at the start of the game, this is why [br]
## the [method load_clef_from_memory] must always be called before usign this method.
## The notes to be used will be from the [constant G_CLEF_NOTES], or [constant F_CLEF_NOTES] [br]
## meanwhile the pitches will come from [constant G_CLEF_PITCHES], or [constant F_CLEF_PITCHES].
func assign_notes_to_lines() -> void:
	for s in range(len(lines)):
		for n in range(len(lines[s])):
			lines[s][n].line_defined_note = clef[n]
			lines[s][n].line_defined_pitch = pitches[n]

## This method organizes the positions of notes currently within the staff. [br]
## It puts them centered on the line that they should be placed in. [br]
## It uses property [member global_position] for the notes as they are not a child [br]
## of [StaffClass], they are a child of [BattleChordSystemClass]
func align_notes() -> void:
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


func align_label(labels) -> void:
	var start_line_offset = CLEFF_START_SEGMENTS*lines[0][0].get_node("mid_line_texture").texture.get_width()
	var end_line_offset = END_LINE_END_SEGMENTS*lines[0][0].get_node("mid_line_texture").texture.get_width()
	var fixed_y_position:float = Globals.center_screen_y / 4.0
	
	
	
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


func get_notes_from_current_chords() -> Array:
	current_chords.clear()
	for measure in lines:
		var chords:Array = []
		for line in measure:
			for note in line.notes_being_held:
				chords.append(note)
		current_chords.append(chords)
	return current_chords
