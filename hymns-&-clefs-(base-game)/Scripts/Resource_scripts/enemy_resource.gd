extends Resource
class_name enemy_resource

@export var texture: Texture2D
@export var texture_frames: int

@export var is_boss_enemy : bool
@export var base_enemy_attack: int
@export var base_enemy_hp: int

enum enemy_action_options {balanced, attacker, defender} 
#balanced = 0 attacker = 1 defender = 2
@export var enemy_action_type: enemy_action_options
