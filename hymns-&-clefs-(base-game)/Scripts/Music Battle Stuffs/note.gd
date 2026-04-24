extends Node2D
class_name NoteClass


signal note_hovered
signal note_hovered_off

var note: String
var position_in_hand
var measure:int
var line_note_is_in
var type: String
var pitch: String

func _ready() -> void:
	get_parent().connect_note_signals(self)



func _on_mouse_clickeable_mouse_entered() -> void:
	emit_signal("note_hovered",self)


func _on_mouse_clickeable_mouse_exited() -> void:
	emit_signal("note_hovered_off",self)
	

func get_note_lenght():
	var note_texture = $Sprite2D
	return (note_texture.texture.get_width() * self.scale.x)
	

func shift_note_type():
	$Sharp.visible = false
	$Flat.visible = false
	if type == "natural":
		type = "sharp"
		$Sharp.visible = true
	elif type == "sharp":
		type = "flat"
		$Flat.visible = true
	else:
		type = "natural"

func get_note_name_with_type() -> String:
	var wrong_name
	if type == "sharp":
		wrong_name = note + "#"
	elif type == "flat":
		wrong_name = note + "b"
	else:
		wrong_name = note
	return ChordManager.get_correct_note_name(wrong_name)





	
