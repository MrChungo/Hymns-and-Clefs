extends Resource
class_name global_rarities_resource



##card rarity weights (by difficulty/world)
@export var card_type_rarities:Dictionary = {"common" : [100,100,100],
									"uncommon": [50,60,75],
									"rare" : [10,15,20]
									}

##enemy rarity weights
@export var enemy_type_rarities:Dictionary = {"common" : 10,
									"uncomon": 5,
									"rare" : 2
									}

##enemy attack pattern for balanced enemiy rarity weights
@export var enemy_balanced_attack_rarity:Dictionary = {"attack" : 10,
											"defend": 5,
											"nothing" : 3
											}

##enemy attack pattern for attacker enemiy rarity weights
@export var enemy_attacker_attack_rarity:Dictionary = {"attack" : 15,
											"defend": 2,
											"nothing" : 5
											}

##enemy attack pattern for defender enemiy rarity weights
@export var enemy_defender_attack_rarity:Dictionary = {"attack" : 5,
											"defend": 10,
											"nothing" : 10
											}
					

##chord rarity weights (by difficulty/world)
@export var chord_type_rarity:Dictionary = {
									"major": [10,8,5],
									"minor": [10,8,5],
									"diminished": [0,2,5],
									"augmented": [0,2,5]
									
									}
