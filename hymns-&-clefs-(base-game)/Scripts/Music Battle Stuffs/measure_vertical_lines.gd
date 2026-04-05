extends Node2D


var line_segments: int


# Called when the node enters the scene tree for the first time.
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

func get_line_lenght():
	var mid = $mid_line_texture
	var end = $end_line_texture_top
	return (mid.texture.get_height() * mid.scale.y) + (end.texture.get_height()*2)
