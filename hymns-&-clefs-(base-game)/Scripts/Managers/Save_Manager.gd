extends Node

const MAIN_SAVE_LOCATION = "uid://chhp04dacxq6i" #"res://Resources/Save States/Main_Save.tres"
const test_save_file = "uid://chmnudsaqsjho" #"res://Resources/Save States/Test_Battle_save.tres"

var save_file_data: save_resource = save_resource.new()

# Called when the node enters the scene tree for the first time.
func _save(save_file_data):
	ResourceSaver.save(save_file_data, test_save_file)

func _load():
	if FileAccess.file_exists(MAIN_SAVE_LOCATION):
		save_file_data = ResourceLoader.load(MAIN_SAVE_LOCATION).duplicate(true)
