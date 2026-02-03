extends Node2D

var COLLISION_MASKS: Dictionary[String, int] = {
	"Card" : 1,
	"CardSlot" : 2
}

var card_being_dragged: Node2D
var screen_size: Vector2
var hand: Array[Card]
var is_hovering_on_card: bool

@onready var camera: Camera2D = $"../Camera2D"


func _ready() -> void:

	if camera:
		screen_size = camera.get_viewport_rect().size
		print("camera", screen_size)
	else:
		screen_size = get_viewport_rect().size
		print("no camera")
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("card_click"):
			var card = raycast_check_for_card("Card")
			if card:
				start_drag(card)
		elif event is InputEventMouseButton and event.is_action_released("card_click"):
			if card_being_dragged:
				finish_drag()

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2.ONE

	
func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var card_slot_found: CardSlot = raycast_check_for_card("CardSlot")
	if card_slot_found and not card_slot_found.card_in_slot:
		card_being_dragged.position = card_slot_found.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.card_in_slot = true
	card_being_dragged = null


func raycast_check_for_card(card_type: String):
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASKS[card_type]
	var result: Array[Dictionary] = space_state.intersect_point(parameters)
	if result.size() > 0:
		match COLLISION_MASKS[card_type]:
			COLLISION_MASKS.Card:
				return get_card_with_highest_z_index(result)
			COLLISION_MASKS.CardSlot:
				return result[0].collider.get_parent()
	return null

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos: Vector2 = get_global_mouse_position()
		card_being_dragged.position = Vector2(
			clamp(mouse_pos.x, -screen_size.x, screen_size.x),
			clamp(mouse_pos.y, -screen_size.y, screen_size.y)
		)
		
func connect_card_signals(card: Card):
	card.hovered.connect(card_hovered)
	card.hovered_off.connect(card_hovered_off)
		
func card_hovered(card: Card):
	if !is_hovering_on_card:
		highlight_card(card, true)

func card_hovered_off(card: Card):
	highlight_card(card, false)
	var new_card_hovered = raycast_check_for_card("Card")
	if new_card_hovered and new_card_hovered != card:
		highlight_card(new_card_hovered, true)
	else:
		is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.15, 1.15)
		card.z_index = 2
		is_hovering_on_card = true
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1
		is_hovering_on_card = false
		
func get_card_with_highest_z_index(cards: Array[Dictionary]) -> Card:
	var highest_z_card: Card = null
	var highest_z_index: int
	
	for i in range(cards.size()):
		if cards[i].collider.get_parent() is Card:
			var current_card: Card = cards[i].collider.get_parent()
			var curr_z_index: int = current_card.z_index
			if curr_z_index > highest_z_index:
				highest_z_card = current_card
				highest_z_index = curr_z_index

	return highest_z_card
