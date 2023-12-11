extends Node

class_name GameManager

@onready var order_manager: Node = $OrderManager

signal toggle_game_paused(is_paused: bool)


func _ready() -> void:
	order_manager.start()


var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		order_manager.pause() if game_paused else order_manager.resume()
		emit_signal("toggle_game_paused", game_paused)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
