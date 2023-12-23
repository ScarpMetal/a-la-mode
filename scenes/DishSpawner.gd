extends Node2D

var order_queue: Array[OrderCreator.Order] = []
var can_spawn: bool = true
var dish_scenes: Dictionary = {
	"steak": preload("res://scenes/dishes/steak_dish.tscn"),
	"salad": preload("res://scenes/dishes/salad_dish.tscn"),
	"sandwich": preload("res://scenes/dishes/sandwich_dish.tscn"),
	"burger": preload("res://scenes/dishes/burger_dish.tscn")
}

signal dish_spawned(dish_instance: Dish)


func _ready() -> void:
	pass


func _on_order_created(order: OrderCreator.Order) -> void:
	order_queue.append(order)
	check_queue()


func check_queue() -> void:
	if not can_spawn or order_queue.size() < 1:
		return

	spawn_dish(order_queue.pop_front())
	can_spawn = false
	await get_tree().create_timer(1.0).timeout
	can_spawn = true
	check_queue()


func spawn_dish(order: OrderCreator.Order) -> void:
	print("spawning dish: ", order.name)
	var dish_instance: Dish = dish_scenes[order.name].instantiate()
	dish_instance.order = order
	dish_instance.z_index = 3
	add_child(dish_instance)
	emit_signal("dish_spawned", dish_instance)
