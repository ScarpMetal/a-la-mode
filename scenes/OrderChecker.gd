extends Node

signal dish_completed(success: bool, order_id: int)
signal scoop_added_to_order(order_id: int, flavor: String, is_correct: bool)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_dish_spawned(dish_instance: Dish) -> void:
	dish_instance.connect("destroyed", _on_dish_destroy)
	dish_instance.connect("ice_cream_hit", _on_ice_cream_hit)

func make_count_dict(arr: Array) -> Dictionary:
	var dict := {}
	for val: Variant in arr:
		if dict.has(val):
			dict[val] += 1
		else:
			dict[val] = 1

	return dict

func is_dish_success(current_flavors: Array[String], required_flavors: Array[String]) -> bool:
	var current_flavors_count := make_count_dict(current_flavors)
	var required_flavors_count := make_count_dict(required_flavors)

	var unique_flavors: Array = required_flavors_count.keys()
	return unique_flavors.all(
		func(flavor: String) -> bool: return (
			current_flavors_count.get(flavor, 0) >= required_flavors_count.get(flavor, 0)
		)
	)

func _on_dish_destroy(current_flavors: Array[String], required_flavors: Array[String], order_id: int) -> void:
	emit_signal("dish_completed", is_dish_success(current_flavors, required_flavors), order_id)

func _on_ice_cream_hit(flavor: String, _current_flavors: Array[String], order_flavors: Array[String], order_id: int) -> void:
	emit_signal("scoop_added_to_order", order_id, flavor, flavor in order_flavors)

