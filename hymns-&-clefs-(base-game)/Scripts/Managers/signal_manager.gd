extends Node2D


func _on_battle_manager_battle_complete() -> void:
	if (len(SaveManager.save_file_data.map_icons) - 1) == SaveManager.save_file_data.current_icon:
		print(len(SaveManager.save_file_data.map_icons))
		print("BOSS TIME")
		pass #(spawn a boss moment)
	SaveManager._save()
	
	get_tree().change_scene_to_file("uid://cbiowlor3xmxe") #"res://Scenes/Areas/map/map.tscn"
