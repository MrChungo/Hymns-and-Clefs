extends Resource
class_name card_resource

@export var card_name :String

@export var texture: Texture2D
@export_range(0,3) var rarity: int
# price should be 3x the rarity level
@export var price: int

@export var shield_points: int
@export var attack_points: int
