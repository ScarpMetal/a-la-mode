extends Node

@export var dishes_complete_hud: DishesCompleteHUD

var orders_created := 0
var orders_completed := 0


func _on_order_created(_dish_name: String, _flavors: Array[String]) -> void:
	orders_created += 1
	dishes_complete_hud.set_out_of_value(orders_created)


func _on_dish_completed() -> void:
	orders_completed += 1
	dishes_complete_hud.set_num_label_value(orders_completed)
