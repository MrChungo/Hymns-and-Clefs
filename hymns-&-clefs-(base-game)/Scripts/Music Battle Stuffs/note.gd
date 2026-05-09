extends Node2D
class_name NoteClass


signal note_hovered ## Signal sent when mouse hovers over the note
signal note_hovered_off ## Signal sent when mouse hovers off the note

var note: String ## This is the base note (Aka A, B, C, etc)
var position_in_hand ## Used to get note back to hand in [BattleChordSystemClass]
var measure:int ## Assigned to have the note remember what measure it belongs in.
var line_note_is_in ## If the note is being held within a [StaffLineClass] This won't be [code] null [/code]
var type: String
var pitch: String

func _ready() -> void:
	get_parent().connect_note_signals(self)



func _on_mouse_clickeable_mouse_entered() -> void:
	emit_signal("note_hovered",self)


func _on_mouse_clickeable_mouse_exited() -> void:
	emit_signal("note_hovered_off",self)
	
## This function gets the lenght of the texture of the note. [br]
## Important to have in mind this is affected by [member scale].
func get_note_lenght():
	var note_texture = $Sprite2D
	return (note_texture.texture.get_width() * self.scale.x)
	

## This method changes the note type to the next type. It follows this loop [br]
## [u] Natural -> Sharp -> Flat [/u]. In addition it also changes the texture [br]
## to match this change.
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

## This method gets the true note name of a [NoteClass] (for example: A#, B, Gb).
## Important to note that the note and type could be wrong (for example: B#) [br]
## but the method [method ChordManagerClass.get_correct_note_name] Is called to fix this.
func get_note_name_with_type() -> String:
	var wrong_name
	if type == "sharp":
		wrong_name = note + "#"
	elif type == "flat":
		wrong_name = note + "b"
	else:
		wrong_name = note
	return ChordManager.get_correct_note_name(wrong_name)





	
