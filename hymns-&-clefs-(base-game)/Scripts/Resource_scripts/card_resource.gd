extends Resource
class_name card_resource

# Card variables
@export var card_name :String

@export var texture: Texture2D
@export_range(0,3) var rarity: int

#card statistics
@export var shield_points: int
@export var attack_points: int
@export var health_gain: int
