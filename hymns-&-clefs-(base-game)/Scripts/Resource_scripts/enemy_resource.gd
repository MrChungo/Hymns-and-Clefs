extends Resource
class_name enemy_resource ## Used to create enemy presets

# enemy sprite animation
@export var enemy_animation:SpriteFrames

#enemy stats & modifiers
@export var is_boss_enemy : bool
@export var base_enemy_attack: int
@export var base_enemy_shield_attack: int
@export var base_enemy_hp: int
@export var base_starting_shield: int

enum enemy_action_options {balanced, attacker, defender} 
#balanced = 0 attacker = 1 defender = 2
@export var enemy_action_type: enemy_action_options
