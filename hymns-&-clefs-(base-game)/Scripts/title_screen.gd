extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	elements_setup()
	background_setup()



func _on_load_game_pressed() -> void:
	SaveManager._load()
	SignalManager.change_scene_to_character_select()


func _on_new_game_pressed() -> void:
	SaveManager._new_save()
	SignalManager.change_scene_to_character_select()

func elements_setup():
	var center_screen_x = Globals.center_screen_x
	var center_screen_y = Globals.center_screen_y
	
	$gameTitle.position.x = center_screen_x
	$gameTitle.position.y = center_screen_y
	
	$New_Game.position.x = center_screen_x - center_screen_x / 2
	$New_Game.position.y = center_screen_y + center_screen_y / 2
	$Load_Game.position.x = center_screen_x + center_screen_x / 2
	$Load_Game.position.y = center_screen_y + center_screen_y / 2
	$Quit.position.x = center_screen_x
	$Quit.position.y = center_screen_y + center_screen_y / 2 + center_screen_y / 4


func background_setup():
	var texture_scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	
	$Background.position.x = Globals.center_screen_x 
	$Background.position.y = Globals.center_screen_y
	
	$Background.scale = Vector2(texture_scale,texture_scale)


func _on_quit_pressed() -> void:
	SignalManager.quit_game()
