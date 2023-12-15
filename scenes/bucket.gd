extends Area2D

class_name Bucket

@onready var bucket_sprite: Sprite2D = $BucketSprite

@export var texture: Texture
@export var flavor: String = "vanilla"

signal bucket_pressed(flavor: String)

var screen: Vector2
var offscreen_position: Vector2
var tween: Tween

@onready var entered_position := global_position


func _ready() -> void:
	bucket_sprite.texture = texture

	screen = get_viewport().get_visible_rect().size
	offscreen_position = Vector2(screen.x + 100, screen.y)
	tween = create_tween()


func tween_to_position(value: Vector2) -> void:
	print("setting bucket position", value, flavor)
	entered_position = value
	create_tween().tween_property(self, "global_position", value, 1).set_trans(Tween.TRANS_SPRING)


func _on_bucket_mouse_entered() -> void:
	(
		create_tween()
		. tween_property(self, "global_position", entered_position - Vector2(0, 60), .2)
		. set_trans(Tween.TRANS_SPRING)
	)


func _on_bucket_mouse_exited() -> void:
	create_tween().tween_property(self, "global_position", entered_position, .2).set_trans(
		Tween.TRANS_SPRING
	)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_mouse"):
		emit_signal("bucket_pressed", flavor)
