extends Sprite2D

class_name ScoopSprite

@export var flavor: String = "vanilla"

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
	texture = scoops[s_flavor].texture
