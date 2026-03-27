extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_load_game_pressed() -> void:
	#SaveManager.save_file_data.world_difficulty = 5
	#SaveManager.save_file_data.current_icon = 5
	#SaveManager._save()
	SignalManager.change_scene_to_map()


func _on_new_game_pressed() -> void:
	SaveManager._new_save()
	SignalManager.change_scene_to_map()
