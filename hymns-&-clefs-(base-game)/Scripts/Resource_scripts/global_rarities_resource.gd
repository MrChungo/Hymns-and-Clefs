extends Resource
class_name global_rarities_resource

#card stuff
@export var card_type_rarities := {"common" : 10,
									"uncomon": 5,
									"rare" : 2
									}

#enemy stuff
@export var enemy_type_rarities := {"common" : 10,
									"uncomon": 5,
									"rare" : 2
									}

#enemy attack weights
@export var enemy_balanced_attack_rarity := {"attack" : 10,
											"defend": 5,
											"nothing" : 2
											}

@export var enemy_attacker_attack_rarity := {"attack" : 15,
											"defend": 2,
											"nothing" : 5
											}

@export var enemy_defender_attack_rarity := {"attack" : 2,
											"defend": 15,
											"nothing" : 5
											}
					

@export var chord_type_rarity := {
									"major": [10,8,5],
									"minor": [10,8,5],
									"diminished": [0,2,5],
									"augmented": [0,2,5]
									
									}
