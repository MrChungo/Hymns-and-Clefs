extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#background_setup()
	pass




func _on_load_game_pressed() -> void:
	#SaveManager.save_file_data.world_difficulty = 3
	#SaveManager.save_file_data.current_icon = 5
	SaveManager._load()
	SignalManager.change_scene_to_map()


func _on_new_game_pressed() -> void:
	SaveManager._new_save()
	SignalManager.change_scene_to_map()



func background_setup():
	var scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	
	$Background.position.x = Globals.center_screen_x 
	$Background.position.y = Globals.center_screen_y
	
	$Background.scale = Vector2(scale,scale)
