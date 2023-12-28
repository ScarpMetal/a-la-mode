extends Node

class_name HealthManager

@export var hearts: Hearts

var health := 3
var max_health := 3

signal health_changed(health: int)


func _ready() -> void:
	hearts.num_active_hearts = health


func _on_dish_completed(success: bool, _order_id: int) -> void:
	return
	if success:
		return

	health -= 1
	hearts.remove_heart()
	print("emitting health changed", health)
	emit_signal("health_changed", health)
