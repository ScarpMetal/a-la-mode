extends Node

class_name Bucket

@export var texture: Texture
@export var flavor: String = "vanilla"
@export var position: Vector2:
	get:
		return position
	set(value):
		print("position changed", value, flavor)
		position = value
		create_tween().tween_property(texture_button, "position", value, 1).set_trans(
			Tween.TRANS_SPRING
		)

signal bucket_pressed(flavor: String)

var screen: Vector2
var offscreen_position: Vector2
var tween: Tween

@onready var texture_button: TextureButton = $Bucket


func _ready() -> void:
	texture_button.texture_normal = texture
	# texture_button.texture_normal = ImageTexture.create_from_image(
	# 	Image.load_from_file("res://assets/ice-cream/FLAVOR_" + flavor + "_BIN.svg")
	# )
	screen = get_viewport().get_visible_rect().size
	offscreen_position = Vector2(screen.x + 100, screen.y)
	tween = create_tween()


func go_to_position(value: Vector2) -> void:
	texture_button.position = value


func _on_bucket_mouse_entered() -> void:
	(
		create_tween()
		. tween_property(texture_button, "position", position + Vector2(0, -60), .2)
		. set_trans(Tween.TRANS_SPRING)
	)


func _on_bucket_mouse_exited() -> void:
	create_tween().tween_property(texture_button, "position", position, .2).set_trans(
		Tween.TRANS_SPRING
	)


func _on_bucket_pressed() -> void:
	emit_signal("bucket_pressed", flavor)
