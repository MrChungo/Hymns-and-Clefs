extends Node2D
class_name map_class
const MAP_ICON_PATH = preload("uid://dqj5ku8jkvvup")#"res://Scenes/Areas/map/map_icon.tscn"

var save: save_resource

var node_group:int 
var node_length:int
var map_icons:Array[String]
var current_icon:int
var screen_width:int
var screen_height:int

var node_icons: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	node_group = 1
	node_length = 6
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	
	#LOAD ICON FROM SAvE FILE, LOAD CURRENT BATTLE FROM FILE
	load_from_save()


func load_from_save():
	node_icons.clear()
	SaveManager._load()
	#SaveManager.save_file_data.map_icons.clear()
	map_icons = SaveManager.save_file_data.map_icons.duplicate()
	current_icon = SaveManager.save_file_data.current_icon
	print(current_icon," ", len(map_icons))
	if !check_if_existing_map() or (current_icon == len(map_icons)):
		map_icons.clear()
		current_icon = 0
		SaveManager.save_file_data.current_icon = 0
		gen_map()
	else:
		load_map()
		
	
func save_to_savefile():
	SaveManager.save_file_data.map_icons = map_icons.duplicate()
	SaveManager._save()
	
func check_if_existing_map():
	if map_icons.size() > 0:
		return true
	else:
		return false




func gen_map():
	
	for n in range(node_length):
		var _type = ""
		if n == node_length:
			_type = "boss_battle"
		else:
			_type = "normal_battle"
			
		gen_map_icon_node(_type)
	update_map_icon_pos()
	
func load_map():
	for n in map_icons:
		new_icon(n)
	update_map_icon_pos()

func update_map_icon_pos():
	for icon in range(len(node_icons)):
		@warning_ignore("integer_division")
		node_icons[icon].position.x = icon*(screen_width/len(node_icons))+90 #HARDCODED NUMBER
		@warning_ignore("integer_division")
		node_icons[icon].position.y = screen_height/2
		if icon == current_icon:
			node_icons[icon].enterable = true
		else:
			node_icons[icon].enterable = false

func gen_map_icon_node(_type):
	new_icon(_type)
	map_icons.append(_type)
	


func new_icon(_type):
	var node = MAP_ICON_PATH.instantiate()
	node.name = "mapIcon"
	node.icon_type = _type
	$"IconManager".add_child.call_deferred(node)
	node_icons.append(node)
	
		
	
