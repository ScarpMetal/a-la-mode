extends Sprite2D

class_name OrderContainer

@export var order: OrderCreator.Order

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
	dish_map[order.name].visible = true

	scoop_left.texture = flavor_map[order.flavors[0]].texture
	scoop_left.visible = true
	if len(order.flavors) > 1:
		scoop_middle.texture = flavor_map[order.flavors[1]].texture
		scoop_middle.visible = true
	if len(order.flavors) > 2:
		scoop_right.texture = flavor_map[order.flavors[2]].texture
		scoop_right.visible = true

func _set_scoop_child_visible(node_name: String, scoop_position: String) -> void:
	match scoop_position:
		"left":
			scoop_left.get_node(node_name).visible = true
		"middle":
			scoop_middle.get_node(node_name).visible = true
		"right":
			scoop_right.get_node(node_name).visible = true

func set_check(scoop_position: String) -> void:
	_set_scoop_child_visible("Check", scoop_position)

func set_x(scoop_position: String) -> void:
	_set_scoop_child_visible("X", scoop_position)

func is_checked_or_xed(scoop_position: String) -> bool:
	match scoop_position:
		"left":
			return (
				scoop_left.get_node("Check").visible == true or
				scoop_left.get_node("X").visible == true
			)
		"middle":
			return (
				scoop_middle.get_node("Check").visible == true or
				scoop_middle.get_node("X").visible == true
			)
		"right":
			return (
				scoop_right.get_node("Check").visible == true or
				scoop_right.get_node("X").visible == true
			)

	return false