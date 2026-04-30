extends Node2D
class_name staffLineClass


var line_defined_note: String # example "A"
var line_defined_pitch: String # example "4"

var notes_being_held: Array = []

var line_segments: int


## Lenghtens line's texture and Area2D to be a certain amounf of segments long [br]
## (a segment is a "middle texture" of the line). [br]
## Imporrtant to have in mind that it resizes the line to be segment + 2 long [br]
## as it also needs to add the texture segments for the end of the line.
func transform_line_to_lenght(segments: int) -> void:
	line_segments = segments
	
	var mid = $mid_line_texture
	
	# Scale the middle
	mid.scale.x = line_segments
	
	# Get REAL width after scaling
	var width = mid.texture.get_width() * mid.scale.x
	
	var texture_offset: float = $end_line_texture_right.texture.get_width()/2.0
	# Position ends based on real width
	$end_line_texture_right.position.x = width / 2.0 + texture_offset
	$end_line_texture_left.position.x = -width / 2.0 - texture_offset
	
	# Scale collision safely
	$Area2D/CollisionShape2D.scale.x = line_segments + 2.0

## Returns lenght of line in pixels. It counts the scale factor of the line too.
func get_line_lenght() -> float:
	var mid = $mid_line_texture
	var end = $end_line_texture_left
	return (mid.texture.get_width() * mid.scale.x) + (end.texture.get_width()*2.0)
	
