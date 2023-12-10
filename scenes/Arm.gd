extends CharacterBody2D

@export var max_speed: int = 2000
@export var slow_at_dist: float = 200


func _physics_process(_delta: float) -> void:
	var mouse_position := get_viewport().get_mouse_position()
	var raw_direction := mouse_position - position
	var direction := raw_direction.normalized()
	var dist := raw_direction.length()
	if dist > 0:
		var unclamped_speed := lerpf(0, max_speed, dist / slow_at_dist)
		var speed := clampf(unclamped_speed, 0, max_speed)
		velocity = (direction * speed)
	else:
		velocity = Vector2(0, 0)

	move_and_slide()
