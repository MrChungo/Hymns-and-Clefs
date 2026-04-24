extends Node2D






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_setup()



func _on_new_game_pressed() -> void:
	SaveManager._new_save()
	SignalManager.change_scene_to_map()



func background_setup():
	var texture_scale = Globals.center_screen_y*2 / $Background.texture.get_height()
	
	$Background.position.x = Globals.center_screen_x 
	$Background.position.y = Globals.center_screen_y
	
	$Background.scale = Vector2(texture_scale,texture_scale)
