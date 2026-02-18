extends Node2D

const MAP_ICON_PATH = preload("uid://dqj5ku8jkvvup")#"res://Scenes/Areas/map/map_icon.tscn"

var node_group:int 
var node_length:int
var map_icons:Array[Node2D]
var current_icon:int
var screen_width
var screen_height


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	node_group = 1
	node_length = 6
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	
	#LOAD ICON FROM SAvE FILE, LOAD CURRENT BATTLE FROM FILE
	current_icon = 2
	
	
	
	
	#GOES LASR
	gen_map(node_length)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gen_map(node_length):
	for n in range(node_length):
		gen_node()
	for icon in range(len(map_icons)):
		map_icons[icon].position.x = icon*(screen_width/node_length)+90 #HARDCODED NUMBER
		map_icons[icon].position.y = screen_height/2
		print(icon , current_icon)
		if icon == current_icon:
			map_icons[icon].enterable = true
		else:
			map_icons[icon].enterable = false
	

func gen_node():
	var node = MAP_ICON_PATH.instantiate()
	$"IconManager".add_child.call_deferred(node)
	node.name = "mapIcon"
	map_icons.append(node)
	#player.load_player_stats(save)
	
