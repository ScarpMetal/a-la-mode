extends Node2D

class_name Hearts

@export var num_active_hearts: int

const full_heart_texture: Resource = preload("res://assets/ui/HEART_FULL.png")
const empty_heart_texture: Resource = preload("res://assets/ui/HEART_EMPTY.png")

@onready var heart_1: Sprite2D = $Heart1
@onready var heart_2: Sprite2D = $Heart2
@onready var heart_3: Sprite2D = $Heart3
@onready var hearts: Array[Sprite2D] = [heart_1, heart_2, heart_3]


func _ready() -> void:
	if not num_active_hearts:
		num_active_hearts = len(hearts)


func add_heart() -> void:
	if num_active_hearts < len(hearts):
		num_active_hearts += 1
		hearts[num_active_hearts - 1].texture = full_heart_texture


func remove_heart() -> void:
	print("removing heart", num_active_hearts)
	if num_active_hearts > 0:
		num_active_hearts -= 1
		hearts[num_active_hearts].texture = empty_heart_texture
