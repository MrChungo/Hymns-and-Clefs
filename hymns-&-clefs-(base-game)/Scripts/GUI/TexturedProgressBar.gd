extends TextureProgressBar

@export var target: Node2D
enum valueBeingDisplayed {HEALTH, SHIELD}
@export var being_displayed: valueBeingDisplayed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target.healthChanged.connect(updateValues)

func updateValues():
	if being_displayed == valueBeingDisplayed.HEALTH:
		value = target.hp
		max_value = target.max_hp
	elif being_displayed == valueBeingDisplayed.SHIELD:
		print(target.shield)
		if target.shield > 0:
			visible = true
			
		else:
			visible = false
		value = target.shield
		max_value = target.shield


func update_positioning(new_position):
	pivot_offset = size/2
	position.x = new_position.x - pivot_offset.x
	position.y = new_position.y - pivot_offset.y











	
