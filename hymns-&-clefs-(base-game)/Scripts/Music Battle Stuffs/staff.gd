extends Node2D

const STAFF_LINE_REFERENCE = preload("uid://l7qvyru1rdq6") #"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff_line.tscn"
const C_SCALE_NOTES = ["G","F","E","D","C","B","A","G","F","E","D"]

var lines := []
var measure_segments = 2

@onready var vertical_spacing = Globals.center_screen_y / 16
@onready var vertical_staff_center_position = Globals.center_screen_y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in measure_segments:
		spawn_lines()
	order_lines()
	order_icons()
	assign_notes_to_lines()


func spawn_lines():
	lines.append(Array())
	for n in range(5+6): # lines + spaces = 11
		var new_line = STAFF_LINE_REFERENCE.instantiate()
		$".".add_child(new_line)
		lines[-1].append(new_line)


func order_lines():
	var target_x_scale = Globals.center_screen_x / 14
	var target_y_scale = Globals.center_screen_y / 100
	
	
	
	for s in range(len(lines)):
		var middle_index = (len(lines[s]) - 1) / 2.0
		
		for n in range(len(lines[s])):
			lines[s][n].scale.x = target_x_scale
			#lines[s][n].scale.y = target_y_scale
			lines[s][n].position.x = Globals.center_screen_x
			lines[s][n].position.y = vertical_staff_center_position + ((n - middle_index) * vertical_spacing)
			
			# Toggle visibility for every other line (ledger lines or spacing)
			# Using get_node("Sprite2D") or find_child to ensure it's found
			var sprite = lines[s][n].get_node_or_null("Sprite2D")
			if sprite:
				sprite.visible = (n % 2 != 0)

func order_icons():
	var cleff_scale = Globals.center_screen_x / 260
	var line_scale = Vector2(Globals.center_screen_x / 190,Globals.center_screen_y / 190)
	var line_y_position = vertical_staff_center_position
	
	#$TrebleClef.scale = Vector2(cleff_scale,cleff_scale)
	$TrebleClef.position.x = Globals.center_screen_x / 6
	$TrebleClef.position.y = vertical_staff_center_position
	
	#$BassClef.scale = Vector2(cleff_scale,cleff_scale)
	$BassClef.position.x = Globals.center_screen_x / 6
	$BassClef.position.y = vertical_staff_center_position - vertical_spacing * 3
	
	#$EndLine.scale = Vector2(Globals.center_screen_x / 185,Globals.center_screen_y / 185)
	$EndLine.position.x = 2*Globals.center_screen_x - Globals.center_screen_x / 22
	$EndLine.position.y = line_y_position
	
	
	for n in range(len(lines) - 1):
		var line = Sprite2D.new()
		var texture = load("uid://b8eroo4yxm34b")# "res://Assets/Sprites/Staff/staff_start_line.png"
		line.texture = texture
		#line.scale = line_scale
		line.position.x = (2*Globals.center_screen_x) / len(lines) + n*(2*Globals.center_screen_x) / len(lines)
		line.position.y = line_y_position
		add_child(line)

	

func assign_notes_to_lines():
	for s in range(len(lines)):
		for n in range(len(lines[s])):
			lines[s][n].line_defined_note = C_SCALE_NOTES[n]
	
	#for s in lines:
		#for n in s:
			#print(n.line_defined_note)
