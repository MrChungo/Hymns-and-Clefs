extends Node

const CARD_RESOURCES_PATH := "res://Resources/Card/"
const CARD_SCENE_PATH := "res://Scenes/card_stuffs/card.tscn"
const CARD_SCENE :=  preload(CARD_SCENE_PATH)
const CARD_DRAW_SPEED := 0.2 #default is 0.2
const STARTING_HAND_SIZE := 3

@export var deck_resource: starting_deck_resource
@export var deck = []
var discard_pile = []
 


func load_from_save():
	deck_resource = SaveManager.save_file_data.deck
	await load_deck_from_resource(deck_resource)
	$RichTextLabel.text = str(deck.size())


func load_deck_from_resource(resource: starting_deck_resource):
	for card in resource.deck_resource:
		deck.insert(0, card)
	deck.shuffle()

func save_to_savefile():
	SaveManager.save_file_data.deck.deck_resource.clear()
	renew_deck()
	for card in deck:
		SaveManager.save_file_data.deck.deck_resource.append(card)
		


func draw_card():
	#if there are cards in the deck, create an instance of the card & place it on hand
	if deck.size() > 0:
		var card_drawn = deck[0]
		
		var new_card = CARD_SCENE.instantiate()
		
		$"../card_manager".add_child(new_card)
		new_card.stats = card_drawn
		new_card.name = card_drawn.card_name
		new_card._update_card_stats(card_drawn)
		$"../Hand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
		new_card.get_node("AnimationPlayer").play("card_flip")
		deck.erase(card_drawn)
		
	#if player draws the last card in the deck, reshuffle
	if deck.size() == 0:
		renew_deck()
		
	$RichTextLabel.text = str(deck.size())
	
func send_card_to_discard(card):
	discard_pile.append(card.stats)
	card.queue_free()
	
	
func renew_deck():
	for n in discard_pile:
		deck.append(n)
	discard_pile.clear()
	deck.shuffle()
	

func _on_battle_manager_card_used(enemy: Variant) -> void:
	send_card_to_discard(enemy.card_in_slot)
	enemy.card_in_slot = null
