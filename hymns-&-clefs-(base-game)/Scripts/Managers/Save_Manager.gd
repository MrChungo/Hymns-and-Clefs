extends Node
## This class manages the saving and loading of game files.
##[br][br]
## I took inspiration and learnt how to use save files from: [br]
## Mostly Mad Productions on [url] https://www.youtube.com/watch?v=xG2GGniUa5o&t=266s [/url]
class_name SaveManagerClass 

const save_location:String = "user://SaveFile.tres"


const test_save_file:String = "uid://chmnudsaqsjho" #"res://Resources/Save States/Test_Battle_save.tres"

const SAVE_FILE_TEMPLATE_LOCATION:String = "res://Resources/Save States/Save_Templates/Default_Save_Template.tres"

var save_file_data: save_resource
var save_file_template: save_resource = preload(SAVE_FILE_TEMPLATE_LOCATION)


## This method creates a new save from [method save_file_template].
func _new_save() -> void:
	var data = save_file_template.duplicate(true)
	data.deck = data.deck.duplicate(true)
	ResourceSaver.save(data, save_location)
	_load()
	
## This method saves the current save file to permanent memory.
func _save() -> void:
	ResourceSaver.save(save_file_data.duplicate(true), save_location)
	_load()

## This method loads the current save file from permanent memory. If it finds no [br]
## save file, it creates and loads a new one.
func _load() -> void:
	#_new_save()
	if FileAccess.file_exists(save_location):
		save_file_data = ResourceLoader.load(save_location, "", ResourceLoader.CACHE_MODE_REPLACE).duplicate(true)
	else:
		_new_save()
		save_file_data = ResourceLoader.load(save_location, "", ResourceLoader.CACHE_MODE_REPLACE).duplicate(true)
