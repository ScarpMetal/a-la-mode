extends Node

@export var flavor: String
var bucket: TextureButton
var original_position: Vector2
var mouse_over_position: Vector2

func _ready() -> void:
	bucket = $VBoxContainer/Bucket
	original_position = Vector2(bucket.position.x, bucket.position.y)
	mouse_over_position = original_position + Vector2(0, -60)

func _on_texture_button_pressed() -> void:
	pass # send a signal that this flavor was chosen

func _on_texture_button_mouse_entered() -> void:
	create_tween().tween_property(bucket, "position", mouse_over_position, .1)

func _on_texture_button_mouse_exited() -> void:
	create_tween().tween_property(bucket, "position", original_position, .1)
