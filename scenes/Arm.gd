extends CharacterBody2D

@export var max_speed: int = 2000
@export var slow_at_dist: float = 200
@export var max_physics_y := 1080
@export var min_physics_y := 400
@export var min_scale := 0.2
@export var max_scale := 1.0


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

	var scale_factor := map_value(
		mouse_position.y, min_physics_y, max_physics_y, min_scale, max_scale
	)
	scale = Vector2(scale_factor, scale_factor)

	move_and_slide()


func map_value(
	value: float, from_min: float, from_max: float, to_min: float, to_max: float
) -> float:
	var clamped_value := clampf(value, from_min, from_max)
	return to_min + (to_max - to_min) * ((clamped_value - from_min) / (from_max - from_min))
