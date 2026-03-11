extends Node2D
class_name PlayerHand

const DEFAULT_CARD_MOVE_SPEED = 0.1

@export var CARD_WIDTH = 200
@export var  HAND_Y_POSITION = 890
var player_hand: Array[Card] = []
var center_screen_x: float
var center_camera_x: float


@onready var card_scene: PackedScene = preload("res://Scenes/Cards/card.tscn")
@onready var card_manager = $"../CardManager"
@onready var camera: Camera2D = $"../Camera2D"

func _ready() -> void:
	center_screen_x = get_viewport_rect().size.x / 2
	center_camera_x = camera.position.x

		
func _process(_delta: float) -> void:
	pass
	
func add_card_to_hand(card: Card, speed: float):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFAULT_CARD_MOVE_SPEED)
	
func update_hand_positions(speed: float):
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card: Card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position, speed)

func remove_card_from_hand(card: Card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
		
func calculate_card_position(index: int) -> float:
	var x_offset = (player_hand.size() - 1) * CARD_WIDTH
	var x_position = center_camera_x + index * CARD_WIDTH - x_offset / 2.0
	return x_position
		
func animate_card_to_position(card: Card, new_position: Vector2, speed: float):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
