extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	elements_setup()
	background_setup()


## Loads existing game savefile and sounds
## then changes scenes to map
func _on_load_game_pressed() -> void:
	SaveManager._load()
	SoundManager.load_from_savefile()
	SignalManager.change_scene_to_map()

## changes scene to character selection & creates a new savefile
func _on_new_game_pressed() -> void:
	SaveManager._new_save()
	SignalManager.change_scene_to_character_select()


## Sets up the position of buttons and their scale
func elements_setup() -> void:
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	
	$Control/New_Game.position.x = center_screen_x - center_screen_x / 2  - $Control/New_Game.pivot_offset.x
	$Control/New_Game.position.y = center_screen_y + center_screen_y / 2.5   - $Control/New_Game.pivot_offset.y
	
	$Control/Load_Game.position.x = center_screen_x  - $Control/Load_Game.pivot_offset.x
	$Control/Load_Game.position.y = center_screen_y + center_screen_y / 2.5   - $Control/Load_Game.pivot_offset.y
	
	$Control/Quit.position.x = center_screen_x  + center_screen_x / 2 - $Control/Quit.pivot_offset.x 
	$Control/Quit.position.y = center_screen_y + center_screen_y / 2.5 - $Control/Quit.pivot_offset.y
	
	
	for button in $Control.get_children():
		if button is TexturedButton:
			button.button_scale = Globals.card_scale_factor * 1.5
			button.scale = Vector2(button.button_scale, button.button_scale)

## Sets up background position and fits the texture to screen width
func background_setup() -> void:
	var texture_scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	
	var title_scale_factor = Globals.center_screen_x/225
	$"Hymns&Clefs".position.x = center_screen_x
	$"Hymns&Clefs".position.y = center_screen_y - center_screen_y / 4
	$"Hymns&Clefs".scale = Vector2(title_scale_factor,title_scale_factor)
	
	
	$Background.position.x = center_screen_x
	$Background.position.y = center_screen_y
	$Background.scale = Vector2(texture_scale,texture_scale)

## Quits game
func _on_quit_pressed() -> void:
	SignalManager.quit_game()
