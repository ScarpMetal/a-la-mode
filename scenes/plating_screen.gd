extends Node2D

@export var game_manager: GameManager

var full_heart_texture: Resource = preload("res://assets/HEART_FULL.svg")
var empty_heart_texture: Resource = preload("res://assets/HEART_EMPTY.svg")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	updateHealthUI()
	pass
	
func updateHealthUI() -> void:
	
	if game_manager.health >= 1:
		$Heart1.texture = full_heart_texture
	else:
		$Heart1.texture = empty_heart_texture
	if game_manager.health >= 2:
		$Heart2.texture = full_heart_texture
	else:
		$Heart2.texture = empty_heart_texture
	if game_manager.health >= 3:
		$Heart3.texture = full_heart_texture
	else:
		$Heart3.texture = empty_heart_texture
