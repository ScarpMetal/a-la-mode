extends CharacterBody2D

@export var max_speed: int = 4000
@export var slow_at_dist: float = 200
@export var max_physics_y := 1080
@export var min_physics_y := 400
@export var min_scale := 0.2
@export var max_scale := 1.0
@export var min_scoop_y_for_dish_collision := 450

signal spawn_node(node: Node, position: Node)

@onready var animationStateMachine: AnimationNodeStateMachinePlayback = $AnimationTree.get(
	"parameters/playback"
)

@onready var held_scoop: ScoopSprite = $ScoopSprite
@onready var falling_scoop_scene: Resource = preload("res://scenes/FallingScoop.tscn")

var holding_flavor := ""


func _ready() -> void:
	pass


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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		match animationStateMachine.get_current_node():
			"idle":
				animationStateMachine.travel("scooping")
			"idle_with_scoop":
				dump_scoop(holding_flavor)
				holding_flavor = ""
				animationStateMachine.travel("dumping_scoop")


func dump_scoop(flavor: String) -> void:
	var falling_scoop: FallingScoop = falling_scoop_scene.instantiate()
	falling_scoop.get_node("ScoopSprite").flavor = flavor
	# get current transform for screen space
	var scoop_transform := transform * held_scoop.transform
	falling_scoop.z_index = 4
	falling_scoop.transform = scoop_transform
	# turn it upside down
	falling_scoop.rotation_degrees = 180
	# make it not spawn on top of itself
	falling_scoop.position += Vector2(
		0, (held_scoop.texture.get_size() * scoop_transform.get_scale()).y
	)
	# set a min height you need to drop from to recognize the dish collision
	falling_scoop.can_hit_dish = falling_scoop.global_position.y < min_scoop_y_for_dish_collision
	emit_signal("spawn_node", falling_scoop)


func _on_bucket_pressed(flavor: String) -> void:
	holding_flavor = flavor


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scooping":
		if holding_flavor:
			held_scoop.set_flavor(holding_flavor)
			animationStateMachine.travel("idle_with_scoop")
		else:
			animationStateMachine.travel("idle")


func map_value(
	value: float, from_min: float, from_max: float, to_min: float, to_max: float
) -> float:
	var clamped_value := clampf(value, from_min, from_max)
	return to_min + (to_max - to_min) * ((clamped_value - from_min) / (from_max - from_min))
