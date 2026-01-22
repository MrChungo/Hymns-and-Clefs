extends Node2D

var enemy_health := 5
var enemy_attack := 1
var enemy_difficulty := 1 #could be in/changed in world

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy_health >= 0: # move later to check only after each turn, not every frame
		_death()

func _death():
	pass
