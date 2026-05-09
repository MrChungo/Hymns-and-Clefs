extends Node2D
class_name StaffVerticalLineClass

var line_segments: int ## A "segment" is a middle texture of the "line" node.


## Lenghtens line's texture and Area2D to be a certain amounf of segments long [br]
## (a segment is a "middle texture" of the line). [br]
## Imporrtant to have in mind that it resizes the line to be segment + 2 long [br]
## as it also needs to add the texture segments for the end of the line.
func transform_line_to_lenght(segments):
	line_segments = segments
	
	var mid = $mid_line_texture
	
	# Scale the middle
	mid.scale.y = line_segments
	
	# Get REAL height after scaling
	var height = mid.texture.get_height() * mid.scale.y
	
	var texture_offset = $end_line_texture_top.texture.get_height()/2
	# Position ends based on real width
	$end_line_texture_bottom.position.y = height / 2 + texture_offset
	$end_line_texture_top.position.y = -height / 2 - texture_offset

## Returns Height of line in pixels. It counts the scale factor of the line too.
func get_line_height():
	var mid = $mid_line_texture
	var end = $end_line_texture_top
	return (mid.texture.get_height() * mid.scale.y) + (end.texture.get_height()*2)
