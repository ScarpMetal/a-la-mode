extends Node2D

var order_container_scene := preload("res://scenes/ui/order_container.tscn")
var num_orders := 0


func _on_order_created(dish_name: String, flavors: Array[String]) -> void:
	var order_container: OrderContainer = order_container_scene.instantiate()
	order_container.dish_name = dish_name
	order_container.flavors = flavors
	order_container.position = Vector2(0, 0)
	add_child(order_container)
	num_orders += 1
