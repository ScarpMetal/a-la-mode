extends Node

class_name GameManager

@onready var order_creator: OrderCreator = $PlatingScreen.get_node("OrderCreator")
@onready var health_manager: HealthManager = $PlatingScreen.get_node("HealthManager")

signal toggle_game_paused(is_paused: bool)

var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		order_creator.pause() if game_paused else order_creator.resume()
		emit_signal("toggle_game_paused", game_paused)


func _ready() -> void:
	print("connecting")
	health_manager.connect("health_changed", _on_health_changed)
	order_creator.start()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_paused = !game_paused


func _on_health_changed(health: int) -> void:
	print(health)
	if health == 0:
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
