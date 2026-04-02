extends Node2D
	

func change_scene_to_map():
	SaveManager._save()
	get_tree().change_scene_to_file("uid://cbiowlor3xmxe") #"res://Scenes/Areas/map/map.tscn"
	
func change_scene_to_battle():
	get_tree().change_scene_to_file("uid://cri5a32uv57us")#"res://Scenes/Areas/battle.tscn"

func change_scene_to_rewards():
	if (len(SaveManager.save_file_data.map_icons)) == SaveManager.save_file_data.current_icon:
		SaveManager.save_file_data.world_difficulty += 1
	get_tree().change_scene_to_file("uid://b2qnuy73pfn82") #"res://Scenes/Areas/rewards_screen.tscn"
