extends Area2D

class_name Scoop

@export var flavor: String

@onready var current_scoop := $CurrentScoop
@onready var scoops := {
	"vanilla": $VanillaScoop,
	"pistachio": $PistachioScoop,
	"strawberry": $StrawberryScoop,
	"chocolate": $ChocolateScoop,
	"blueberry": $BlueberryScoop
}


func _ready() -> void:
	set_flavor(flavor)


func set_flavor(s_flavor: String) -> void:
	current_scoop.texture = scoops[s_flavor].texture
