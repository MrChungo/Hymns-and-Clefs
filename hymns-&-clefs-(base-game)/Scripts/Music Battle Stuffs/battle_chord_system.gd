extends Node2D



const STAFF_SCENE = preload("uid://cavmm10t43b7r")#"res://Scenes/Music Battle System Stuffs/Staff Stuff/staff.tscn"

var staff

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load("uid://du6yetekcwf5c") #"res://Scripts/Managers/chord_manager.gd"
	set_up_staff()
	ChordManager


func set_up_staff():
	$SubmitChords.visible = true
	
	staff = STAFF_SCENE.instantiate()
	staff.position.x = Globals.center_screen_x
	staff.position.y = Globals.center_screen_y + Globals.center_screen_y/4
	$".".add_child(staff)
