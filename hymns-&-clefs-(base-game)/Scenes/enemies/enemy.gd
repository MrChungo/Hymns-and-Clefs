extends Node2D

@export var stats : enemy_resource

var enemy_hp :int
var enemy_attack :int
var enemy_difficulty := 1 #could be in/changed in world

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_hp = stats.base_enemy_hp * enemy_difficulty
	enemy_attack = stats.base_enemy_attack * enemy_difficulty


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# can be moved later to end of round check or smth !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if enemy_hp >= 0: # move later to check only after each turn, not every frame
		_death()

func _death():
	pass
