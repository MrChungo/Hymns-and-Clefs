extends Node2D

const STAFF_LINE_REFERENCE = preload("uid://l7qvyru1rdq6") #"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff_line.tscn"
const C_SCALE_NOTES = ["G","F","E","D","C","B","A","G","F","E","D"]

var lines := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_lines()
	order_lines()
	order_icons()
	assign_notes_to_lines()


func spawn_lines():
	for n in range(5+6): # lines + spaces = 11
		var new_line = STAFF_LINE_REFERENCE.instantiate()
		$".".add_child(new_line)
		lines.append(new_line)


func order_lines():
	var vertical_spacing = Globals.center_screen_y / 16
	var target_x_scale = Globals.center_screen_x / 14
	var target_y_scale = Globals.center_screen_y / 100
	
	for n in range(len(lines)):
		lines[n].scale.x = target_x_scale
		lines[n].scale.y = target_y_scale
		lines[n].position.x = Globals.center_screen_x
		lines[n].position.y = Globals.center_screen_y + (n * vertical_spacing)
		
		# Toggle visibility for every other line (ledger lines or spacing)
		# Using get_node("Sprite2D") or find_child to ensure it's found
		var sprite = lines[n].get_node_or_null("Sprite2D")
		if sprite:
			sprite.visible = (n % 2 != 0)

func order_icons():
	var icon_scale = Globals.center_screen_x / 280
	
	$TrebleClef.scale = Vector2(icon_scale,icon_scale)
	$TrebleClef.position.x = Globals.center_screen_x / 6
	$TrebleClef.position.y = lines[5].position.y
	
	$BassClef.scale = Vector2(icon_scale,icon_scale)
	$BassClef.position.x = Globals.center_screen_x / 6
	$BassClef.position.y = lines[5].position.y
	

func assign_notes_to_lines():
	for n in range(len(lines)):
		lines[n].line_defined_note = C_SCALE_NOTES[n]
	for n in lines:
		print(n.line_defined_note)
