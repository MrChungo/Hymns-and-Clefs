extends Node2D
class_name battle_class
#eventually this part might spawn the mobs and do the things instead of battle_manager
#batttle manager should only care about battle logic.

func _ready() -> void:
	background_setup()

func background_setup():
	var current_background 
	hide_backgrounds()
	
	if SaveManager.save_file_data.world_difficulty == 1:
		current_background = $BackgroundWorldOne
	elif SaveManager.save_file_data.world_difficulty == 2:
		current_background = $BackgroundWorldTwo
	elif SaveManager.save_file_data.world_difficulty == 3:
		current_background = $BackgroundWorldThree
	else:
		current_background = $BackgroundWorldThree
	
	print(SaveManager.save_file_data.world_difficulty)
	current_background.visible = true
	
	var texture_scale = Globals.center_screen_y*2 / current_background.texture.get_height()
	
	current_background.position.x = Globals.center_screen_x 
	current_background.position.y = Globals.center_screen_y
	
	current_background.scale = Vector2(texture_scale,texture_scale)

func hide_backgrounds():
	$BackgroundWorldOne.visible = false
	$BackgroundWorldTwo.visible = false
	$BackgroundWorldThree.visible = false
