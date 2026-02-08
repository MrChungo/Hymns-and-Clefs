extends Node2D



var rng = RandomNumberGenerator.new()


func get_weighted_rarity(item_rarity):
	rng.randomize()
	var weighted_sum = 0
	
	for n in item_rarity:
		weighted_sum += item_rarity[n]
	var rarity_chosen = rng.randi_range(0,weighted_sum)
	
	for n in item_rarity:
		if rarity_chosen <= item_rarity[n]:
			return n
		else:
			rarity_chosen -= item_rarity[n]
