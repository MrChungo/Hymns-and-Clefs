extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	elements_setup()
	background_setup()



func _on_new_game_pressed() -> void:
	SaveManager._new_save()
	SignalManager.change_scene_to_character_select()

func elements_setup():
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	
	$Control/New_Game.position.x = center_screen_x - center_screen_x / 5  - $Control/New_Game.pivot_offset.x
	$Control/New_Game.position.y = center_screen_y + center_screen_y / 4.25   - $Control/New_Game.pivot_offset.y
	$Control/Quit.position.x = center_screen_x  + center_screen_x / 5 - $Control/Quit.pivot_offset.x
	$Control/Quit.position.y = center_screen_y + center_screen_y / 4.25 - $Control/Quit.pivot_offset.y
	
	
	for button in $Control.get_children():
		if button is TexturedButton:
			button.button_scale = Globals.card_scale_factor * 1.5
			button.scale = Vector2(button.button_scale, button.button_scale)

func background_setup():
	var texture_scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	var title_scale_factor = Globals.center_screen_x/225
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	
	
	$YouWon.position.x = center_screen_x
	$YouWon.position.y = center_screen_y - center_screen_y / 3.25
	$YouWon.scale = Vector2(title_scale_factor,title_scale_factor)
	
	
	
	$Background.position.x = Globals.center_screen_x 
	$Background.position.y = Globals.center_screen_y
	
	$Background.scale = Vector2(texture_scale,texture_scale)


func _on_quit_pressed() -> void:
	SaveManager._new_save()
	SignalManager.quit_game()
