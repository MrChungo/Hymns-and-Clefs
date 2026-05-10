extends Node
class_name DeckClass

const CARD_RESOURCES_PATH := "res://Resources/Card/"
const CARD_SCENE_PATH := "res://Scenes/card_stuffs/card.tscn"
const CARD_SCENE :=  preload(CARD_SCENE_PATH)
const CARD_DRAW_SPEED := 0.2 #default is 0.2
const STARTING_HAND_SIZE := 3


@onready var deck_x_position = Globals.center_screen_x / 6
@onready var deck_y_position = Globals.center_screen_y + Globals.center_screen_y / 1.5

@export var deck_resource: starting_deck_resource
@export var deck = []
var discard_pile = []


func _ready() -> void:
	self.position.x = deck_x_position
	self.position.y = deck_y_position

	var deck_scale = Globals.card_scale_factor
	self.scale = Vector2(deck_scale, deck_scale)
	%RichTextLabel.visible = false
	

func load_from_save():
	deck_resource = SaveManager.save_file_data.deck
	await load_deck_from_resource(deck_resource)
	var text_size = int(round(Globals.center_screen_x / 16))

	%RichTextLabel.add_theme_font_size_override("normal_font_size", text_size)
	
	%RichTextLabel.text = str(deck.size())
	%RichTextLabel.visible = true
	
	%RichTextLabel.fit_content = true


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
		new_card.deck_reference = self
		new_card.move_card_to_deck()
		%card_manager.add_child(new_card)
		
		var card_scale = Globals.card_scale_factor
		new_card.scale = Vector2(card_scale,card_scale)
		new_card.stats = card_drawn
		new_card.name = card_drawn.card_name
		new_card._update_card_stats(card_drawn)
		%Hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
		new_card.get_node("AnimationPlayer").play("card_flip")
		deck.erase(card_drawn)
		
	#if player draws the last card in the deck, reshuffle
	if deck.size() == 0:
		renew_deck()
		
	%RichTextLabel.text = str(deck.size())
	
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
