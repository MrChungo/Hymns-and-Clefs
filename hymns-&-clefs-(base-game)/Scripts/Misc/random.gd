extends Node2D
class_name RandomClass

var rng:RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	SaveManager._load()
	rng.randomize()

## This method gets a random [int] from within an inclusive range.
func get_random_int(min_int:int,max_int:int):
	return rng.randi_range(min_int,max_int)
	

## This method gets a random rarity from within a [member global_rarities_resource.card_type_rarities].
## Which is a weighted Dictionary.
func get_weighted_rarity(item_rarity:Dictionary):
	var weighted_sum = 0
	
	# Add up all rarity weights
	for n in item_rarity:
		weighted_sum += item_rarity[n]
	
	# Pick a random number between 0 and the total weight
	var rarity_chosen = rng.randi_range(0,weighted_sum)
	
	# Go through each rarity
	for n in item_rarity:
		# If the random number lands in this rarity's range,
		# return that rarity
		if rarity_chosen <= item_rarity[n]:
			return n
		else:
			# Otherwise subtract this weight
			# and continue checking
			rarity_chosen -= item_rarity[n]

## This method gets a random rarity from within a member within a [global_rarities_resource].
## Which is a weighted Dictionary, but the valuies of the keys are lists, [br]
## whose indexes are meant to be correlated to [member SaveManagerClass.save_file_data.world_difficulty]
func get_weighted_rarity_by_world(item_rarity):
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
		
		var enemy_index = SaveManager.save_file_data.world_difficulty - 1
		if enemy_index > 2:
			enemy_index = 2
		
		return path + enemies_in_folder[enemy_index]


func get_random_card_resource(card_rarity):
	
	var path = "res://Resources/Card/"
	var cards_in_folder = []
	

	if card_rarity == "common":
		path = "res://Resources/Card/Common_Rarity/"
		cards_in_folder = dir_contents(path)
	elif card_rarity == "uncommon":
		path = "res://Resources/Card/uncommon_Rarity/"
		cards_in_folder = dir_contents(path)
	elif card_rarity == "rare":
		path = "res://Resources/Card/Rare_Rarity/"
		cards_in_folder = dir_contents(path)
		
	return path + cards_in_folder[get_random_int(0,len(cards_in_folder)-1)]

func dir_contents(path):
	var files = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if !dir.current_is_dir():
				# Remove .remap and .import suffixes added during export
				var clean_name = file_name.replace(".remap", "").replace(".import", "")
				
				# Add to list only if it's a unique resource we want
				if !files.has(clean_name):
					files.append(clean_name)
			
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path: ", path)
		
	return files
