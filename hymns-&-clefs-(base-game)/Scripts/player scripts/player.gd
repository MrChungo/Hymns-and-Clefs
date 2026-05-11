extends Node2D
class_name player_class

## Updates Health & Shield bars when called
signal healthChanged()

#gets the animations ready whenever player node spawns
@onready var current_animation = $AnimatedSprite2D.animation

#player loaded stats
var hp: int
var max_hp: int
var shield: int = 0


## loads player stats from [SaveManagerClass.save_file_data] & copies them to local player variables. [br]
## Involves player hp & max hp [br]
## Loads and starts playing the texture animations (depending on cleff type) [br]
## Updates positioning of health/shielf bars & updates their values to match loaded variales.
func load_player_stats() -> void:
	if SaveManager.save_file_data.cleff_type == 0: # Treble Clef
		$AnimatedSprite2D.play("IdleFluteWizard")
	elif SaveManager.save_file_data.cleff_type == 1: # Bass Clef
		$AnimatedSprite2D.play("IdleCelloWizard")
	
	current_animation = $AnimatedSprite2D.animation
	
	update_progress_bars_positioning()
	
	#updates local variables
	hp = SaveManager.save_file_data.current_player_hp
	max_hp = SaveManager.save_file_data.max_player_hp
	
	#calls ater this node is fully set up (baseically moves for later)
	healthChanged.emit.call_deferred()


## Saves current player variables into Savefile [br]
## Involves player hp & max hp
func save_player_stats() -> void:
	SaveManager.save_file_data.current_player_hp = hp
	SaveManager.save_file_data.max_player_hp = max_hp

## Updates the positioning of possibale health and shield bars [br]
## (must be a child of AnimatedSprite2D node) & centers them.
func update_progress_bars_positioning() -> void:
	var current_texture = $AnimatedSprite2D.sprite_frames.get_frame_texture(current_animation,0)
	var texture_size = current_texture.get_size() #gets size of first frame of animation
	
	var health_bar_position_x = -texture_size.x / 2
	var shield_bar_position_x = -texture_size.x / 2
	
	var health_bar_position_y = -texture_size.y
	var shield_bar_position_y = -texture_size.y - $AnimatedSprite2D/HealthBar.size.y * 1.25
	
	
	$AnimatedSprite2D/HealthBar.update_positioning(Vector2(health_bar_position_x,health_bar_position_y))
	$AnimatedSprite2D/ShieldBar.update_positioning(Vector2(shield_bar_position_x,shield_bar_position_y))

## Deletes player node
func death() -> void:
	self.queue_free()












	
