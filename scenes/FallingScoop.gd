extends Area2D

class_name FallingScoop

@export var INITIAL_SPEED := 300.0
@export var GRAVITY := 1000.0

var velocity := Vector2(0, INITIAL_SPEED)
var can_hit_dish := false


func _physics_process(delta: float) -> void:
	velocity += Vector2(0, GRAVITY * delta)
	position += velocity * delta


func freeze() -> void:
	velocity = Vector2.ZERO
	GRAVITY = 0
