extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_dish_spawned(dish_instance: Dish) -> void:
	dish_instance.connect("ice_cream_hit", _on_dish_ice_cream_hit)
	dish_instance.connect("destroyed", _on_dish_destroy)


func _on_dish_ice_cream_hit(hit_flavor: String, required_flavors: Array[String]) -> void:
	if hit_flavor not in required_flavors:
		pass
		# descrease health


func _on_dish_destroy(current_flavors: Array[String], required_flavors: Array[String]) -> void:
	if current_flavors.all(func(flavor: String) -> bool: return flavor in required_flavors):
		print("hi")
		# increase completed dishes
	else:
		print("hi")
		# decrease health