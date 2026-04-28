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
	
	background_setup()
	
	


func load_from_save():
	node_icons.clear()
	await SaveManager._load()
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
		if n == node_length - 1:
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
		var icon_scale = Globals.center_screen_x/150
		node_icons[icon].scale = Vector2(icon_scale,icon_scale)
		
		@warning_ignore("integer_division")
		
		#node_icons[icon].position.x = icon*(screen_width/len(node_icons)) + node_icons[-1].get_node("BattleIcon").texture.get_width()  #HARDCODED NUMBER
		
		@warning_ignore("integer_division")
		node_icons[icon].position.y = screen_height/2
		if icon == current_icon:
			node_icons[icon].enterable = true
		else:
			node_icons[icon].enterable = false
	await get_tree().process_frame
	setup_map_icon_textures()
	order_icons_x_pos()


func order_icons_x_pos():
	
	var total_icon_width = 0.0
	for icon in node_icons:
		total_icon_width += icon.get_icon_lenght()
	
	var padding = Globals.center_screen_x / 12
	var usable_width = screen_width - (padding * 2)
	# Calculate spacing (using a fixed width, e.g., screen width)
	var spacing_length = usable_width - total_icon_width
	var singular_spacing = spacing_length / (node_icons.size() + 1)

	# Calculate the total width of the entire 'row' (icons + gaps)
	var total_row_width = total_icon_width + (singular_spacing * (node_icons.size() - 1))

	# Start at negative half of the row width so the middle of the row sits at Manager's (0,0)
	var current_x = -total_row_width / 2

	for icon in node_icons:
		var icon_w = icon.get_icon_lenght()
		# Position icon relative to the row start
		icon.position.x = current_x + (icon_w / 2)
		# Advance current_x by icon width + spacing
		current_x += icon_w + singular_spacing

	# Place the manager in the middle of the screen
	$IconManager.position.x = Globals.center_screen_x

func gen_map_icon_node(_type):
	new_icon(_type)
	map_icons.append(_type)
	


func new_icon(_type):
	var node = MAP_ICON_PATH.instantiate()
	node.name = "mapIcon"
	node.icon_type = _type
	$"IconManager".add_child.call_deferred(node)
	node_icons.append(node)
	
		


func background_setup():
	var texture_scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	
	$Control/Quit.position.x = Globals.center_screen_x / 8 - $Control/Quit.pivot_offset.x 
	$Control/Quit.position.y = Globals.center_screen_y + Globals.center_screen_y / 1.5  - $Control/Quit.pivot_offset.y
	for button in $Control.get_children():
		if button is TexturedButton:
			button.button_scale = Globals.card_scale_factor
			button.scale = Vector2(button.button_scale, button.button_scale)
	
	
	
	$Background.position.x = Globals.center_screen_x 
	$Background.position.y = Globals.center_screen_y
	
	$Background.scale = Vector2(texture_scale,texture_scale)
	
	
	

func setup_map_icon_textures():
	for icon in range(len(node_icons)):
		if icon < current_icon:
			node_icons[icon].setup_texture(true)
		else:
			node_icons[icon].setup_texture(false)
	


func _on_quit_pressed() -> void:
	SaveManager._save()
	SignalManager.change_scene_to_title()
