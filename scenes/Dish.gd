extends CharacterBody2D

@export var SPEED := 200.0
@export var a_la_mode_texture: CompressedTexture2D

@onready var texture_button: TextureButton = $DishButton


func _physics_process(_delta: float) -> void:
	velocity = Vector2(SPEED, 0)

	move_and_slide()


func _on_dish_button_pressed() -> void:
	texture_button.texture_normal = a_la_mode_texture
