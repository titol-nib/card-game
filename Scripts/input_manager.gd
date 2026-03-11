extends Node2D
class_name InputManager

signal left_mouse_button_clicked
signal left_mouse_button_released

@onready var card_manager = $"../CardManager"
@onready var deck = $"../Deck"
@onready var player_hand = $"../PlayerHand"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("card_click"):
			left_mouse_button_clicked.emit()
			raycast_at_cursor()
		else:
			left_mouse_button_released.emit()

func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result: Array[Dictionary] = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == card_manager.COLLISION_MASKS.Card:
			var card_found = result[0].collider.get_parent()
			if card_found:
				card_manager.start_drag(card_found)
		elif result_collision_mask == card_manager.COLLISION_MASKS.Deck:
			deck.draw_card()
		else:
			print("hi")
			return null