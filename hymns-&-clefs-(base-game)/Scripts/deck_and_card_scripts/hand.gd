'''
Using tutorial to base card logic

https://www.youtube.com/watch?v=2jMcuKdRh2w
'''

extends Node2D

func _input(event):
	#checks list of all events (key inputs)
	#checks the type of event (use this for later reference)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("click")
			#raycast to check if is pressing a card
		else:
			print("clank")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
