extends Node2D
class_name map_class
const MAP_ICON_PATH = preload("uid://dqj5ku8jkvvup")#"res://Scenes/Areas/map/map_icon.tscn"

var save: save_resource

var node_group:int 
var node_length:int
var map_icons:Array[Node2D]
var current_icon:int
var screen_width:int
var screen_height:int


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

func load_from_save(loaded_save):
	save = loaded_save
	map_icons = save.map_icons
	current_icon = save.current_icon
	
func check_if_existing_map():
	if save.map_icons.size() > 0:
		return true
	else:
		return false




func gen_map(_node_length):
	for n in range(_node_length):
		gen_map_icon_node()
	update_map_icon_pos()
	display_loaded_icons()
	
	

func update_map_icon_pos():
	for icon in range(len(map_icons)):
		@warning_ignore("integer_division")
		map_icons[icon].position.x = icon*(screen_width/len(map_icons))+90 #HARDCODED NUMBER
		@warning_ignore("integer_division")
		map_icons[icon].position.y = screen_height/2
		print(icon , current_icon)
		if icon == current_icon:
			map_icons[icon].enterable = true
		else:
			map_icons[icon].enterable = false
	pass

func gen_map_icon_node():
	var node = MAP_ICON_PATH.instantiate()
	node.name = "mapIcon"
	map_icons.append(node)
	#player.load_player_stats(save)
	
func display_loaded_icons():
	for n in map_icons:
		$"IconManager".add_child.call_deferred(n)
	
