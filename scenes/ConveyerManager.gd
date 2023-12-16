extends Node

@export var speed: float = 1.4
var conveyers: Array[Sprite2D]
var wrap_at: int = 2800
var loopback_width: int = wrap_at + 879


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	conveyers = [$ConveyerBelt1, $ConveyerBelt2, $ConveyerBelt3]


func sort_conveyers(c1: Sprite2D, c2: Sprite2D) -> bool:
	if c1.position.x < c2.position.x:
		return true
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# sort them first so we can set their z_index accordingly
	conveyers.sort_custom(sort_conveyers)

	# set positions
	for index in conveyers.size():
		var conveyer: Sprite2D = conveyers[index]
		conveyer.position.x += speed
		if conveyer.position.x > wrap_at:
			conveyer.position.x -= loopback_width
			conveyer.z_index = index

	# print("====")
	# for conveyer in conveyers:
	# 	print(conveyer.get_instance_id())
