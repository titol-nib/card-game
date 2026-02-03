extends Node2D
class_name PlayerHand

@export var  HAND_COUNT: int = 2
@export var CARD_WIDTH = 200
@export var  HAND_Y_POSITION = 890
var player_hand: Array[Card] = []
var center_screen_x: float


@onready var card_scene: PackedScene = preload("res://Scenes/Cards/card.tscn")
@onready var card_manager = $"../CardManager"
func _ready() -> void:
	center_screen_x = get_viewport_rect().size.x / 2
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		card_manager.add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)
		
func _process(delta: float) -> void:
	pass
	
func add_card_to_hand(card: Card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.hand_position)
	
func update_hand_positions():
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card: Card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position)

func remove_card_from_hand(card: Card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()
		
func calculate_card_position(index):
	var x_offset = (player_hand.size() - 1) * CARD_WIDTH
	var x_position = center_screen_x + index * CARD_WIDTH - x_offset / 2
	return x_position
		
func animate_card_to_position(card: Card, new_position: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
