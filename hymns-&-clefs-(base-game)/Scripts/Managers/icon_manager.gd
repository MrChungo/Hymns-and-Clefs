extends Node2D
class_name IconManagerClass

const COLLISION_MASK_ICON:int = 1

var screen_size
var is_hovering_on_icon:bool
var entered:bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
#	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)

## Connects signals of map icons.
func connect_icon_signals(icon):
	icon.connect("icon_hovered", on_hovered_over_icon)
	icon.connect("icon_hovered_off", on_hovered_off_icon)


## This method makes it so that icons that are hover-over-able, and enterable scale up in size.
func on_hovered_over_icon(icon):
	entered = true
	if !is_hovering_on_icon && icon.enterable:
		is_hovering_on_icon = true
		highlight_icon(icon,true)
	

## this method makes it so that an icon scales back in size after it's done being [br]
## hovered over.
func on_hovered_off_icon(icon):
	entered = false
	if icon.enterable:
		highlight_icon(icon, false)
		#check if hovered off icon straight on to another icon
		var new_icon_hovered = raycast_check_for_icon()
		if new_icon_hovered:
			highlight_icon(new_icon_hovered, true)
		else:
			is_hovering_on_icon = false
				

## This method scales an icon in size.
func highlight_icon(icon, hovered):
	var icon_scale = Globals.center_screen_x/150
	
	if hovered && icon.enterable:
		icon.scale = icon.scale*1.2
		icon.z_index = 2
	else:
		icon.scale = Vector2(icon_scale,icon_scale)
		icon.z_index = 1
		

## This method cheks for icons below the mouse.
func raycast_check_for_icon():
	#checks if icon is below mouse position
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_ICON
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return get_icon_with_highest_z_index(result)
	else:
		return null
	
## This method returns the icon with the highest z-index within a set of icons.
func get_icon_with_highest_z_index(icons):
	#asume first icon passed has the highest z index
	var highest_z_icon = icons[0].collider.get_parent()
	var highest_z_index = highest_z_icon.z_index
	
	#loop through rest of the icons & check for a higher z index
	
	for i in range(1, icons.size()):
		var current_icon = icons[i].collider.get_parent()
		if current_icon.z_index > highest_z_index:
			highest_z_icon = current_icon
			highest_z_index = current_icon.z_index
	return highest_z_icon


func _on_input_manager_left_mouse_button_released() -> void:
	var icon = raycast_check_for_icon()
	if entered == true and icon.enterable:
		await $"..".save_to_savefile()
		SignalManager.change_scene_to_battle()
		
