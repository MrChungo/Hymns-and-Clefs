extends Node2D
class_name SignalManagerClass ## This class manages signals. Currently involving scene changes.

#This method changes Scene to clef_selection
func change_scene_to_character_select() -> void:
	SaveManager._save()
	get_tree().change_scene_to_file("uid://ct7uccre3bnlr") #res://Scenes/Screens/clef_selection.tscn

#This method changes Scene to map
func change_scene_to_map() -> void:
	SaveManager._save()
	get_tree().change_scene_to_file("uid://cbiowlor3xmxe") #"res://Scenes/Areas/map/map.tscn"

#This method changes Scene to battle
func change_scene_to_battle() -> void:
	get_tree().change_scene_to_file("uid://cri5a32uv57us")#"res://Scenes/Areas/battle.tscn"

#This method changes Scene to title_screen
func change_scene_to_title() -> void:
	get_tree().change_scene_to_file("uid://djm6a0kyrnuod")#"res://Scenes/Screens/title_screen.tscn"

#This method changes Scene to rewards_screen
func change_scene_to_rewards() -> void:
	if (len(SaveManager.save_file_data.map_icons)) == SaveManager.save_file_data.current_icon:
		SaveManager.save_file_data.world_difficulty += 1
	get_tree().change_scene_to_file("uid://b2qnuy73pfn82") #"res://Scenes/Areas/rewards_screen.tscn"

#This method changes Scene to death_screen
func change_scene_to_death() -> void:
	get_tree().change_scene_to_file("uid://drn5v72bxkeoa") #"res://Scenes/Screens/death_screen.tscn"

#This method changes Scene to win_screen
func change_scene_to_win() -> void:
	get_tree().change_scene_to_file("uid://cubygmhh5ssn0") #"res://Scenes/Screens/Win_screen.tscn"

#Quits game
func quit_game() -> void:
	get_tree().quit()
