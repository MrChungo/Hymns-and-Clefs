extends Node2D
class_name player_class

signal healthChanged()

@onready var current_animation = $AnimatedSprite2D.animation

var hp: int
var max_hp: int
var shield: int = 0

# Called when the node enters the scene tree for the first time.


func load_player_stats():
	#SaveManager.save_file_data
	if SaveManager.save_file_data.cleff_type == 0:
		$AnimatedSprite2D.play("IdleFluteWizard")
	elif SaveManager.save_file_data.cleff_type == 1:
		$AnimatedSprite2D.play("IdleCelloWizard")
	
	current_animation = $AnimatedSprite2D.animation
	
	update_progress_bars_positioning()
	
	hp = SaveManager.save_file_data.current_player_hp
	max_hp = SaveManager.save_file_data.max_player_hp
	
	healthChanged.emit.call_deferred()

func save_player_stats():
	SaveManager.save_file_data.current_player_hp = hp
	SaveManager.save_file_data.max_player_hp = max_hp


func update_progress_bars_positioning():
	var current_texture = $AnimatedSprite2D.sprite_frames.get_frame_texture(current_animation,0)
	var texture_size = current_texture.get_size()
	
	var health_bar_position_x = -texture_size.x / 2
	var shield_bar_position_x = -texture_size.x / 2
	
	var health_bar_position_y = -texture_size.y
	var shield_bar_position_y = -texture_size.y - $AnimatedSprite2D/HealthBar.size.y * 1.25

	
	$AnimatedSprite2D/HealthBar.update_positioning(Vector2(health_bar_position_x,health_bar_position_y))
	$AnimatedSprite2D/ShieldBar.update_positioning(Vector2(shield_bar_position_x,shield_bar_position_y))





func death():
	self.queue_free()












	
