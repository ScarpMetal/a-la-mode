extends Node

class_name HealthManager

@export var hearts: Hearts

var health := 3
var max_health := 3

signal health_changed(health: int)


func _ready() -> void:
	hearts.num_active_hearts = health


func _on_dish_failed() -> void:
	health -= 1
	hearts.remove_heart()
	print("emitting health changed", health)
	emit_signal("health_changed", health)
