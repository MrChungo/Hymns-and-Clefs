extends Node
## code here is based on the series Godot 4 CARD GAME from Barry's Dev Hell, on youtube [br]
## find it on [url] https://youtube.com/playlist?list=PLNWIwxsLZ-LMYzxHlVb7v5Xo5KaUV7Tq1&si=W6UocyFLIWn6tzMn [/url]
class_name DeckClass

const CARD_RESOURCES_PATH := "res://Resources/Card/"
const CARD_SCENE_PATH := "res://Scenes/card_stuffs/card.tscn"
const CARD_SCENE :=  preload(CARD_SCENE_PATH)
const CARD_DRAW_SPEED:float = 0.2 #default is 0.2
const STARTING_HAND_SIZE: int= 3


@onready var deck_x_position = Globals.center_screen_x / 6
@onready var deck_y_position = Globals.center_screen_y + Globals.center_screen_y / 1.5

@export var deck_resource: starting_deck_resource
@export var deck:Array = [] ## This member holds [card_resource] within it's [Array]it [b] DOES NOT [/b] hold [card_Class].
var discard_pile:Array = []## This member holds [card_resource] within it's [Array]it [b] DOES NOT [/b] hold [card_Class].


func _ready() -> void:
	setup_deck_position_and_scale()

## This method sets up the deck to it's default position and scale.
func setup_deck_position_and_scale() -> void:
	self.position.x = deck_x_position
	self.position.y = deck_y_position

	var deck_scale = Globals.card_scale_factor
	self.scale = Vector2(deck_scale, deck_scale)
	%RichTextLabel.visible = false

## This method loads the current deck saved on [SaveManagerClass.save_file_data.deck] into [br]
## [member deck], and updates the label on top of the deck to display the remaining cards.
func load_from_save():
	deck_resource = SaveManager.save_file_data.deck
	load_deck_from_resource(deck_resource)
	var text_size:int = int(round(Globals.center_screen_x / 16))

	%RichTextLabel.add_theme_font_size_override("normal_font_size", text_size)
	
	%RichTextLabel.text = str(deck.size())
	%RichTextLabel.visible = true
	
	%RichTextLabel.fit_content = true

## This method loads a [starting_deck_resource] into [member deck]
func load_deck_from_resource(resource: starting_deck_resource) -> void:
	for card in resource.deck_resource:
		deck.insert(0, card)
	deck.shuffle()

## This method replaces the deck on [SaveManagerClass.save_file_data.deck] with the deck [br]
## on [member deck]. Effectively saving the deck.
func save_to_savefile() -> void:
	SaveManager.save_file_data.deck.deck_resource.clear()
	renew_deck()
	for card in deck:
		SaveManager.save_file_data.deck.deck_resource.append(card)
		

## This method draws a card from the deck to the hand. It does this by instanciating [br]
## a random [card_resource] from within [member deck], deleting it from [member deck] [br]
## adding it to the hand. In addition to this, if there are no more cards to draw from [br]
## [member deck] it will bring the cards from [member discard_pile] into [member deck] [br]
## reshuffle the deck, and attempt to draw a card again.
func draw_card() -> void:
	#if there are cards in the deck, create an instance of the card & place it on hand
	if deck.size() > 0:
		var card_drawn:card_resource = deck[0]
		var new_card:card_class = CARD_SCENE.instantiate()
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


## This method appends a [card_resource] into the [member discard_pile]
func send_card_to_discard(card) -> void:
	discard_pile.append(card.stats)
	card.queue_free()
	
## This method, moves all [card_resource] from [member discard_pile] into [member deck] [br] 
## and shuffles all of the indexes within [member deck]. 
func renew_deck() -> void:
	for n in discard_pile:
		deck.append(n)
	discard_pile.clear()
	deck.shuffle()
	
## This method sends a card to the [member discard_pile] from a target [enemy_class.card_in_slot] [br]
## and removes it from the enemy.
func _on_battle_manager_card_used(enemy: enemy_class) -> void:
	send_card_to_discard(enemy.card_in_slot)
	enemy.card_in_slot = null
