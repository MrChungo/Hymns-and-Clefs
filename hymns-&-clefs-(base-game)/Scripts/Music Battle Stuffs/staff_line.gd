extends Node2D
class_name staffLineClass


var line_defined_note: String
var line_defined_pitch: String

var notes_being_held: Array = []

var line_segments: int

#func _ready() -> void:
	#transform_line_to_lenght(5)
	#print(get_line_lenght())
	#self.position = Vector2(Globals.center_screen_x,Globals.center_screen_y)

# Called when the node enters the scene tree for the first time.
func transform_line_to_lenght(segments):
	line_segments = segments
	
	var mid = $mid_line_texture
	
	# Scale the middle
	mid.scale.x = line_segments
	
	# Get REAL width after scaling
	var width = mid.texture.get_width() * mid.scale.x
	
	var texture_offset = $end_line_texture_right.texture.get_width()/2
	# Position ends based on real width
	$end_line_texture_right.position.x = width / 2 + texture_offset
	$end_line_texture_left.position.x = -width / 2 - texture_offset
	
	# Scale collision safely
	$Area2D/CollisionShape2D.scale.x = line_segments + 2

func get_line_lenght():
	var mid = $mid_line_texture
	var end = $end_line_texture_left
	return (mid.texture.get_width() * mid.scale.x) + (end.texture.get_width()*2)
	
