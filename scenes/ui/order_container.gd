extends Sprite2D

class_name OrderContainer

@export var dish_name: String = ""
@export var flavors: Array[String] = []

@onready var scoop_left := $ScoopLeft
@onready var scoop_middle := $ScoopMiddle
@onready var scoop_right := $ScoopRight

@onready var flavor_map := {
	"blueberry": $Blue,
	"chocolate": $Brown,
	"pistachio": $Green,
	"strawberry": $Pink,
	"vanilla": $White
}

@onready var dish_map := {"burger": $Burger, "salad": $Salad, "sandwich": $Sandwich, "steak": $Steak}


func _ready() -> void:
	dish_map[dish_name].visible = true

	scoop_left.texture = flavor_map[flavors[0]].texture
	scoop_left.visible = true
	if len(flavors) > 1:
		scoop_middle.texture = flavor_map[flavors[1]].texture
		scoop_middle.visible = true
	if len(flavors) > 2:
		scoop_right.texture = flavor_map[flavors[2]].texture
		scoop_right.visible = true
