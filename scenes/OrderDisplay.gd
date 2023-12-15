extends Control

class_name OrderDisplay

@export var texture_store: UITextureStore

@export var dish_name: String = ""
@export var flavors: Array[String] = []

@onready var scoop_left := $ScoopLeft
@onready var scoop_middle := $ScoopMiddle
@onready var scoop_right := $ScoopRight


func _ready() -> void:
	# var dish_node: TextureRect = texture_store.get_dish(dish_name)
	# add_child(dish_node.new())

	scoop_left.texture = texture_store.get_scoop(flavors[0])
	if len(flavors) > 1:
		scoop_middle.texture = texture_store.get_scoop(flavors[1])
	if len(flavors) > 2:
		scoop_middle.texture = texture_store.get_scoop(flavors[2])
