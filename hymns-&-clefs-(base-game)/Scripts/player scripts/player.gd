extends Node2D
class_name player_class

var hp: int
var max_hp: int
var shield: int

# Called when the node enters the scene tree for the first time.


func load_player_stats():
	#SaveManager.save_file_data
	hp = SaveManager.save_file_data.current_player_hp
	max_hp = SaveManager.save_file_data.max_player_hp
	
	update_label()

func save_player_stats():
	SaveManager.save_file_data.current_player_hp = hp
	SaveManager.save_file_data.max_player_hp = max_hp

func update_label():
	var text = "[center]Hp: %d, Sh: %d[/center]" % [self.hp, self.shield]
	$Control/Health.text = text
	
	

func death():
	self.queue_free()
