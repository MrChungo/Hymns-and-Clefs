extends Node2D

const STAFF_LINE_REFERENCE = preload("uid://l7qvyru1rdq6") #"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff_line.tscn"
const MEASURE_VER_LINE_REFERENCE = preload("uid://rahc3qlfgf7x") #"res://Scenes/Music Battle System Stuffs/Staff Stuff/measure_vertical_lines.tscn"
const END_MEASURE_VER_LINE_REFERENCE = preload("uid://bktwnnt44k6br")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/end_measure_vertical_lines.tscn"
const C_SCALE_NOTES = ["G","F","E","D","C","B","A","G","F","E","D"]
const MEASURE_WIDTH_SEGMENTS = 18

#var scale

var lines := []
var measure_separators := []
var end_line
var measure_segments : int



var vertical_spacing: float



func load_staff(segments):
	measure_segments = segments
	#var staff_scale = Globals.center_screen_x/280
	#self.scale = Vector2(staff_scale,staff_scale)
	#self.position = Vector2(Globals.center_screen_x,Globals.center_screen_y)
	
	spawn_measures()
	set_spacing_variables()
	
	order_lines()
	spawn_measure_separators()
	order_measure_separators()
	spawn_and_order_end_line()
	
	order_icons()
	assign_notes_to_lines()



func set_spacing_variables():
	vertical_spacing = lines[-1][-1].get_node("mid_line_texture").texture.get_height() * 2
	
	print(vertical_spacing)

func spawn_measures():
	var extra_start_segments = 10
	var extra_end_segments = 2
	
	var line_width
	for n in range(measure_segments):
		if measure_segments == 1:
			line_width = MEASURE_WIDTH_SEGMENTS + extra_end_segments + extra_start_segments
		else:
			if n == 0:
				line_width = MEASURE_WIDTH_SEGMENTS + extra_start_segments
			elif n == measure_segments - 1:
				line_width = MEASURE_WIDTH_SEGMENTS + extra_end_segments
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
			lines[s][n].line_defined_note = C_SCALE_NOTES[n]
	
	#for s in lines:
		#for n in s:
			#print(n.line_defined_note)
