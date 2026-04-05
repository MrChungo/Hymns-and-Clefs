extends Node2D

const STAFF_LINE_REFERENCE = preload("uid://l7qvyru1rdq6") #"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff_line.tscn"
const C_SCALE_NOTES = ["G","F","E","D","C","B","A","G","F","E","D"]
const MEASURE_WIDTH_SEGMENTS = 20

var lines := []
var measure_segments = 8


var vertical_spacing: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = Vector2(Globals.center_screen_x,Globals.center_screen_y)
	print(Globals.center_screen_x*2)
	
	spawn_measures()
	set_spacing_variables()
	
	order_lines()
	
	order_icons()
	assign_notes_to_lines()


func set_spacing_variables():
	vertical_spacing = lines[-1][-1].get_node("mid_line_texture").texture.get_height() * 2
	
	print(vertical_spacing)

func spawn_measures():
	var line_width
	for n in range(measure_segments):
		if measure_segments == 1:
			line_width = MEASURE_WIDTH_SEGMENTS + 4 + 8 #(do the math later of staff + end line)
		else:
			if n == 0:
				line_width = MEASURE_WIDTH_SEGMENTS + 8
			elif n == measure_segments:
				line_width = MEASURE_WIDTH_SEGMENTS + 4
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
			lines[s][n].scale.x = target_x_scale
			#lines[s][n].scale.y = target_y_scale
			lines[s][n].position.x = Globals.center_screen_x
			lines[s][n].position.y = vertical_staff_center_position + ((n - middle_index) * vertical_spacing)
			
			# Toggle visibility for every other line (ledger lines or spacing)
			# Using get_node("Sprite2D") or find_child to ensure it's found
			var sprite = lines[s][n].get_node_or_null("Sprite2D")
			if n % 2 == 0:
				var line = measure[n]
				line.get_node("mid_line_texture").visible = false
				line.get_node("end_line_texture_left").visible = false
				line.get_node("end_line_texture_right").visible = false
		x_offset += measure_width
	
	


func order_icons():
	pass

	

func assign_notes_to_lines():
	for s in range(len(lines)):
		for n in range(len(lines[s])):
			lines[s][n].line_defined_note = C_SCALE_NOTES[n]
	
	#for s in lines:
		#for n in s:
			#print(n.line_defined_note)
