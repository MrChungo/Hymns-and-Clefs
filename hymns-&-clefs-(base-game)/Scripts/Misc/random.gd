extends Node2D

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	get_random_enemy(2, false)

func get_random_int(min_int:int,max_int:int):
	rng.randomize()
	return rng.randi_range(min_int,max_int)
	
	

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


func get_weighted_rarity_by_world(item_rarity):
	
	rng.randomize()
	var weighted_sum = 0

	for n in item_rarity:
		weighted_sum += item_rarity[n][SaveManager.save_file_data.world_difficulty - 1] 
	var rarity_chosen = rng.randi_range(0,weighted_sum)
	
	for n in item_rarity:
		if rarity_chosen <= item_rarity[n][SaveManager.save_file_data.world_difficulty - 1] :
			return n
		else:
			rarity_chosen -= item_rarity[n][SaveManager.save_file_data.world_difficulty - 1] 
			

func get_random_enemy(world:int , is_boss:bool):
	var path = "res://Resources/Enemy/"
	if !is_boss:
		if world == 1:
			path = "res://Resources/Enemy/WorldOneEnemies/" 
			
			
			return
		elif world == 2:
			path = "res://Resources/Enemy/WorldTwoEnemies/"
			dir_contents(path)
		elif world == 3:
			path = "res://Resources/Enemy/WorldThreeEnemies/"
			dir_contents(path)
			

func dir_contents(path):
	var files = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files
	
