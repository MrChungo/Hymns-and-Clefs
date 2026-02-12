extends Node2D


var save: save_resource
var current_hp: int
var max_hp: int
var hp: int
var shield: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func load_player_stats(save):
	current_hp = save.current_player_hp
	max_hp = save.max_player_hp
	shield = save.current_player_shield
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp >= 0: # move later to check only after each turn, not every frame
		_death()

func _death():
	pass
