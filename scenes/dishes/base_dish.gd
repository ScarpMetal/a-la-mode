extends CharacterBody2D

class_name Dish

@export var speed := 200.0
@export var required_flavors: Array[String] = []

signal ice_cream_hit(hit_flavor: String, required_flavors: Array[String])
signal destroyed(current_flavors: Array[String], required_flavors: Array[String])

var current_flavors: Array[String] = []

func _physics_process(_delta: float) -> void:
	velocity = Vector2(speed, 0)

	move_and_slide()

func destroy() -> void:
	queue_free()
	emit_signal("destroyed", current_flavors, required_flavors)