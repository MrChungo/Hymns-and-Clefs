extends Node2D


func _on_battle_manager_battle_complete() -> void:
	get_tree().change_scene_to_file("uid://cri5a32uv57us")#"res://Scenes/Areas/battle.tscn"
