extends Node

const CARD_RESOURCES_PATH := "res://Resources/Card/"
const CARD_SCENE_PATH := "res://Scenes/card_stuffs/card.tscn"
const CARD_SCENE :=  preload(CARD_SCENE_PATH)
const CARD_DRAW_SPEED := 0.2 #default is 0.2
const STARTING_HAND_SIZE := 3

@export var deck_resource: starting_deck_resource
@export var deck = []
var discard_pile = []

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_resource = load("res://Resources/Deck/Deck Presets/Default_Deck_Preset.tres")
	load_deck_from_resource(deck_resource)
	$RichTextLabel.text = str(deck.size())
	for i in range(STARTING_HAND_SIZE):
		draw_card()

func load_deck_from_resource(resource: starting_deck_resource):
	for card in resource.deck_resource:
		deck.insert(0, card)
	deck.shuffle()

func draw_card():

	#if there are cards in the deck, create an instance of the card & place it on hand
	if deck.size() > 0:
		var card_drawn = deck[0]
		deck.erase(card_drawn)
		var new_card = CARD_SCENE.instantiate()
		
		$"../card_manager".add_child(new_card)
		new_card.stats = card_drawn
		new_card.name = card_drawn.card_name
		new_card._update_card_stats(card_drawn)
		$"../Hand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
		new_card.get_node("AnimationPlayer").play("card_flip")
		
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
