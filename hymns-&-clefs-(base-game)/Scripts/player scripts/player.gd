extends Node2D
class_name player_class

var save: save_resource
var hp: int
var max_hp: int
var shield: int

# Called when the node enters the scene tree for the first time.


func load_player_stats(_save):
	save = _save
	hp = save.current_player_hp
	max_hp = save.max_player_hp
	shield = save.current_player_shield
	
	update_label()

func update_label():
	var text = "[center]Hp: %d, Sh: %d[/center]" % [self.hp, self.shield]
	$Control/Health.text = text
	
	

func death():
	self.queue_free()
