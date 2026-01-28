extends Node
#TUTORIAL USED: https://www.youtube.com/watch?v=dyfU-5Nbn_4

const plane_len = 30
#depends on availible space
const node_count = plane_len * plane_len /12
const path_count = 12

func generate():
	#randomize map every time
	randomize()
	
	#generate points on grid
	var points = []
	points.append(Vector2(0, plane_len /2))
	points.append(Vector2(plane_len, plane_len / 2))
