extends Node2D
class_name enemy_class

signal healthChanged()

@export var stats : enemy_resource ## Stats from the enemy template.

var hp :int
var max_hp: int
var attack :int
var shield: int = 0
var shield_attack: int
var enemy_difficulty:int = 1 #could be in/changed in world 
var enemy_action_type: int #0 = balanced, 1 = attacker, 2 = defender
var enemy_next_action:String ## This can either be "nothing", "attack", or "defend"

var card_in_slot: Node2D

var enemy_scale:int
var texture_size:Vector2

func _ready() -> void:
	
	update_next_action_position()

## This method loads an enemy from a [enemy_resource], it updates all of it's [br]
## stats and textures from the file. It also updates the health & shield bars [br]
## on the enemy, and also starts playing the animation foe each one of them.
func update_enemy_stats(loaded_stats:enemy_resource) -> void:
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

## This method updates the positioning of the health/shield bars of the enemy.
func update_progress_bars_positioning():
	var current_texture = $AnimatedSprite2D.sprite_frames.get_frame_texture("default",0)
	texture_size = current_texture.get_size()
	
	var health_bar_position_x = 0
	var shield_bar_position_x = 0
	
	var health_bar_position_y = -texture_size.y / 2
	var shield_bar_position_y = -texture_size.y / 2 - $AnimatedSprite2D/HealthBar.size.y * 1.5
	
	
	$AnimatedSprite2D/HealthBar.update_positioning(Vector2(health_bar_position_x,health_bar_position_y))
	$AnimatedSprite2D/ShieldBar.update_positioning(Vector2(shield_bar_position_x,shield_bar_position_y))
	

## This method updates the [i] next enemy action [/i] label on top of the enemy to reflect [br]
## whatever is on [member enemy_next_action]
func update_next_action_texture():
	var atlas_height = $AnimatedSprite2D/NextActionSprite.texture.region.size.y
	
	if enemy_next_action == "nothing":
		$AnimatedSprite2D/NextActionSprite.visible = false
	elif enemy_next_action == "attack":
		$AnimatedSprite2D/NextActionSprite.visible = true
		$AnimatedSprite2D/NextActionSprite.texture.region = Rect2(0,0,atlas_height,atlas_height)
	elif enemy_next_action == "defend":
		$AnimatedSprite2D/NextActionSprite.visible = true
		$AnimatedSprite2D/NextActionSprite.texture.region = Rect2(32,0,atlas_height,atlas_height)

## This method updates the positioning of the [i] next enemy action [/i] label to the top of the enemy.
func update_next_action_position():
	var atlas_height = $AnimatedSprite2D/NextActionSprite.texture.region.size.y
	$AnimatedSprite2D/NextActionSprite.position.y = - atlas_height * 2



## This method removes the [enemy_class] from the scene tree.
func death():
	self.queue_free()
	
