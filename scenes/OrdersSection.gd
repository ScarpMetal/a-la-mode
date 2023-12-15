extends Control

@export var texture_store: UITextureStore

var order_scene := preload("res://scenes/OrderDisplay.tscn")

var num_orders := 0


func _on_order_created(dish_name: String, flavors: Array[String]) -> void:
	var new_order_display: OrderDisplay = order_scene.instantiate()
	new_order_display.texture_store = texture_store
	new_order_display.dish_name = dish_name
	new_order_display.flavors = flavors
	new_order_display.position = Vector2(num_orders * 235, 0)
	add_child(new_order_display)
	num_orders += 1
