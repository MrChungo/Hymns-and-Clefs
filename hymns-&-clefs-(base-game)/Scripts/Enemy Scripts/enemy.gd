extends Node2D
class_name enemy_class

signal healthChanged()

@export var stats : enemy_resource

var hp :int
var max_hp: int
var attack :int
var shield: int = 0
var shield_attack: int
var enemy_difficulty := 1 #could be in/changed in world
var enemy_action_type: int #0 = balanced, 1 = attacker, 2 = defender
var enemy_next_action

var card_in_slot: Node2D

var enemy_scale:int
var texture_size:Vector2


func update_enemy_stats(loaded_stats):
	stats = loaded_stats
	
	hp = stats.base_enemy_hp * enemy_difficulty
	attack = stats.base_enemy_attack * enemy_difficulty
	shield = stats.base_starting_shield * enemy_difficulty
	shield_attack = stats.base_enemy_shield_attack * enemy_difficulty
	enemy_action_type = stats.enemy_action_type
	
	
	$AnimatedSprite2D.sprite_frames = stats.enemy_animation
	$AnimatedSprite2D.play("default")
	
	update_progress_bars_positioning()
	
	healthChanged.emit.call_deferred()


func update_progress_bars_positioning():
	var current_texture = $AnimatedSprite2D.sprite_frames.get_frame_texture("default",0)
	texture_size = current_texture.get_size()
	
	var health_bar_position_x = 0
	var shield_bar_position_x = 0
	
	var health_bar_position_y = -texture_size.y / 2
	var shield_bar_position_y = -texture_size.y / 2 - $AnimatedSprite2D/HealthBar.size.y * 1.5

	
	$AnimatedSprite2D/HealthBar.update_positioning(Vector2(health_bar_position_x,health_bar_position_y))
	$AnimatedSprite2D/ShieldBar.update_positioning(Vector2(shield_bar_position_x,shield_bar_position_y))


func death():
	self.queue_free()
	
