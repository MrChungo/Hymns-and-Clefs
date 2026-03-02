extends Node

const save_location = "user://SaveFile.tres"


const test_save_file = "uid://chmnudsaqsjho" #"res://Resources/Save States/Test_Battle_save.tres"

const SAVE_FILE_TEMPLATE_LOCATION = "uid://dbeyhpubeidew" #"res://Resources/Save States/Save_Templates/Default_Save_Template.tres"

var save_file_data: save_resource = save_resource.new()
var save_file_template: save_resource = load(SAVE_FILE_TEMPLATE_LOCATION)



func _new_save():
	ResourceSaver.save(save_file_template, save_location)
	
# Called when the node enters the scene tree for the first time.
func _save():
	ResourceSaver.save(save_file_data, save_location)

func _load():
	if FileAccess.file_exists(save_location):
		save_file_data = ResourceLoader.load(save_location).duplicate(true)
	else:
		_new_save()
