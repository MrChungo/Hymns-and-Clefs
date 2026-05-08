extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_setup()
	elements_setup()


## Sets up the position of buttons and their scale [br]
## Buttons are equdistantly placed using the center of the screen as their center
func elements_setup():
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	
	$Control/Quit.position.x = Globals.center_screen_x / 8 - $Control/Quit.pivot_offset.x 
	$Control/Quit.position.y = Globals.center_screen_y + Globals.center_screen_y / 1.5  - $Control/Quit.pivot_offset.y
	
	
	for button in $Control.get_children():
		if button is AnimatedButton:
			button.button_scale = Globals.card_scale_factor * 3
			button.scale = Vector2(button.button_scale, button.button_scale)
		elif button is TexturedButton:
			button.button_scale = Globals.card_scale_factor
			button.scale = Vector2(button.button_scale, button.button_scale)
	
	$Control/TrebleClef.position.x = center_screen_x  - center_screen_x / 4 - $Control/TrebleClef.pivot_offset.x
	$Control/TrebleClef.position.y = center_screen_y - $Control/TrebleClef.pivot_offset.y
	
	$"Control/BassClef".position.x = center_screen_x  + center_screen_x / 4 - $"Control/BassClef".pivot_offset.x
	$"Control/BassClef".position.y = center_screen_y - $"Control/BassClef".pivot_offset.y

## Sets up background position and fits the texture to screen width
func background_setup():
	var texture_scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	
	
	$Background.position.x = center_screen_x
	$Background.position.y = center_screen_y
	$Background.scale = Vector2(texture_scale,texture_scale)

## When called it assigns the cleff type of saved data to F clef
func _on_bass_clef_pressed() -> void:
	SaveManager.save_file_data.cleff_type = 1 as save_resource.clefs
	SaveManager._save()
	SoundManager.load_from_savefile()
	SignalManager.change_scene_to_map()

## When called it assigns the cleff type of saved data to G clef
func _on_treble_clef_pressed() -> void:
	SaveManager.save_file_data.cleff_type = 0 as save_resource.clefs
	SaveManager._save()
	SoundManager.load_from_savefile()
	SignalManager.change_scene_to_map()

## Changes scene to title when button is pressed
func _on_quit_pressed() -> void:
	SignalManager.change_scene_to_title()
