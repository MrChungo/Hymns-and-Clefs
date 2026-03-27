extends Node2D

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	SaveManager._load()

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
	var world_diff_index_ref: int
	
	
	if SaveManager.save_file_data.world_difficulty > 3:
		world_diff_index_ref = 2
	else:
		world_diff_index_ref = SaveManager.save_file_data.world_difficulty - 1
	
	for n in item_rarity:
		weighted_sum += item_rarity[n][world_diff_index_ref] 
	var rarity_chosen = rng.randi_range(0,weighted_sum)
	
	for n in item_rarity:
		if rarity_chosen <= item_rarity[n][world_diff_index_ref] :
			return n
		else:
			rarity_chosen -= item_rarity[n][world_diff_index_ref] 
			

func get_random_enemy_resource(is_boss:bool):
	var world_difficulty: int
	
	if SaveManager.save_file_data.world_difficulty > 3:
		world_difficulty = 3
	else:
		world_difficulty = SaveManager.save_file_data.world_difficulty
	
	var path = "res://Resources/Enemy/"
	var enemies_in_folder = []
	
	if !is_boss:
		if world_difficulty == 1:
			path = "res://Resources/Enemy/WorldOneEnemies/" 
			enemies_in_folder = dir_contents(path)
		elif world_difficulty == 2:
			path = "res://Resources/Enemy/WorldTwoEnemies/"
			enemies_in_folder = dir_contents(path)
		
		elif world_difficulty == 3:
			path = "res://Resources/Enemy/WorldThreeEnemies/"
			enemies_in_folder = dir_contents(path)
		
		return path + enemies_in_folder[get_random_int(0,len(enemies_in_folder)-1)]
		
	else:
		path = "res://Resources/Enemy/Bosses/"
		enemies_in_folder = dir_contents(path)
		
		return path + enemies_in_folder[SaveManager.save_file_data.world_difficulty - 1]
		

func dir_contents(path):
	var files = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				pass
			else:
				#print("Found file: " + file_name)
				files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files.duplicate()
	
