extends Node2D






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_setup()




func background_setup():
	var texture_scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	
	$Background.position.x = Globals.center_screen_x 
	$Background.position.y = Globals.center_screen_y
	
	$Background.scale = Vector2(texture_scale,texture_scale)


func _on_bass_clef_pressed() -> void:
	SaveManager.save_file_data.cleff_type = 1 as save_resource.clefs
	SaveManager._save()
	SoundManager.load_from_savefile()
	SignalManager.change_scene_to_map()


func _on_treble_clef_pressed() -> void:
	SaveManager.save_file_data.cleff_type = 0 as save_resource.clefs
	SaveManager._save()
	SoundManager.load_from_savefile()
	SignalManager.change_scene_to_map()
