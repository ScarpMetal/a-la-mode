extends Node

class_name GameManager

var health: int
var selected_flavor: String
@onready var order_creator: OrderCreator = $PlatingScreen.get_node("OrderCreator")

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
	health = 3
	order_creator.start()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_paused = !game_paused


func _process(_delta: float) -> void:
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
