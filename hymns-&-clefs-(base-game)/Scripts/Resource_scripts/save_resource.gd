extends Resource
class_name save_resource

#general variables
@export var world_difficulty: int # must start at 1!!!

enum clefs {G, F} # 0 is G clef(Treble Clef), 1 is F clef(Bass clef)
@export var cleff_type: clefs

#map variables
@export var map_icons: Array[String]
@export var current_icon:int

#player specific variables
@export var current_player_hp: int
@export var max_player_hp: int
@export var deck: starting_deck_resource

@export var hand_size: int
