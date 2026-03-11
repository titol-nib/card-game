extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Cards/card.tscn"
const CARD_DRAW_SPEED: float = 1
var player_deck: Array[String] = ["Knight", "Knight", "Knight"]

@onready var player_hand: PlayerHand = $"../PlayerHand"
@onready var card_manager: CardManager = $"../CardManager"
@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
    update_deck_count()

func update_deck_count():
    rich_text_label.text = str(player_deck.size())

func draw_card():
    player_deck.pop_front()
    update_deck_count()

    if player_deck.size() == 0:
        $Area2D/CollisionShape2D.disabled = true
        $Sprite2D.visible = false

    var card_scene: PackedScene = preload(CARD_SCENE_PATH)
    var new_card = card_scene.instantiate()
    card_manager.add_child(new_card)
    new_card.name = "Card"
    player_hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)