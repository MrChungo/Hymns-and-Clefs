extends TextureProgressBar

var label_current
var label_max

@export var target: Node2D
enum valueBeingDisplayed {HEALTH, SHIELD}
@export var being_displayed: valueBeingDisplayed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_label()
	target.healthChanged.connect(updateValues)
	

func create_label():
	var scale_factor = Globals.card_scale_factor * 4
	var font_sz = self.texture_over.get_size().y * scale_factor
	
	# --- Current Label (Left) ---
	label_current = Label.new()
	add_child(label_current)
	label_current.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label_current.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label_current.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	label_current.scale = Vector2(1 / scale_factor, 1 / scale_factor)
	label_current.add_theme_font_size_override("font_size", font_sz)
	
	# Set pivot to the left center so it stays on the left when scaling
	label_current.pivot_offset = Vector2(size.x * 0.1, -size.y / 4) 

	# --- Max Label (Right) ---
	label_max = Label.new()
	add_child(label_max)
	label_max.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label_max.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label_max.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	label_max.scale = Vector2(1 / scale_factor, 1 / scale_factor)
	label_max.add_theme_font_size_override("font_size", font_sz)
	
	# IMPORTANT: Set pivot to the right center so it stays on the right
	label_max.pivot_offset = Vector2(size.x * 0.8, -size.y / 4)
	

func updateValues():
	if being_displayed == valueBeingDisplayed.HEALTH:
		value = target.hp
		max_value = target.max_hp
	elif being_displayed == valueBeingDisplayed.SHIELD:
		if target.shield > 0:
			visible = true
			
		else:
			visible = false
		value = target.shield
		max_value = target.shield
	
	update_label()


func update_positioning(new_position):
	pivot_offset = size/2
	position.x = new_position.x - pivot_offset.x
	position.y = new_position.y - pivot_offset.y


func update_label():
	# Show as "50 / 100" or percentage "50%"
	var current_value = value
	var maximum_value = max_value

	
	label_current.text = str(int(current_value))
	label_max.text = str(int(maximum_value))
	if value > 0:
		label_current.visible = true
		label_max.visible = true
		
	else:
		label_current.visible = false
		label_max.visible = false








	
