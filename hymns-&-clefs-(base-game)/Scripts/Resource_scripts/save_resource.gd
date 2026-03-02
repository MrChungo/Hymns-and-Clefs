extends Resource
class_name save_resource

#general stuff
@export var world_difficulty: int # must start at 1!!!

#map stuff
@export var map_icons: Array[String]
@export var current_icon:int

#player stuffs
@export var current_player_hp: int
@export var max_player_hp: int
@export var deck: starting_deck_resource

@export var hand_size: int

#battle stuff (add smth if needed)
