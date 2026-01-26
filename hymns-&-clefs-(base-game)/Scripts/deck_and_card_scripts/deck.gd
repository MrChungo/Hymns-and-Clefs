extends Node

const CARD_RESOURCES_PATH := "res://Resources/Card/"
const CARD_SCENE_PATH := "res://Scenes/card_stuffs/card.tscn"
const CARD_SCENE :=  preload(CARD_SCENE_PATH)
const CARD_DRAW_SPEED := 0.2 #default is 0.2

@export var deck_resource: starting_deck_resource
@export var deck = []
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_resource = load("res://Scripts/Resource_scripts/TEST DECK OH MY GOD.tres")
	load_deck_from_resource(deck_resource)
	$RichTextLabel.text = str(deck.size())

func load_deck_from_resource(resource: starting_deck_resource):
	for n in resource.deck_resource:
		var new_card = CARD_SCENE.instantiate()
		$"../card_manager".add_child(new_card)
		new_card.stats = n
		deck.insert(0, new_card)
		new_card.name = n.card_name
	print(deck)
		
		

func draw_card():
	var card_drawn = deck[0]
	deck.erase(card_drawn)
	
	#if player draws the last card in the deck, disable the deck
	if deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
		
	$RichTextLabel.text = str(deck.size())
	
	var new_card = CARD_SCENE.instantiate()
	$"../card_manager".add_child(new_card)
	new_card.name = "Card"
	$"../Hand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
