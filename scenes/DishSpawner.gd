extends Node2D


class DishQueueItem:
	var name: String
	var flavors: Array[String]

	func _init(p_name: String, p_flavors: Array[String]) -> void:
		name = p_name
		flavors = p_flavors


var dish_queue: Array[DishQueueItem] = []
var can_spawn: bool = true
var dish_scenes: Dictionary = {
	"steak": preload("res://scenes/dishes/steak_dish.tscn"),
	"veggies": preload("res://scenes/dishes/veggies_dish.tscn"),
	"salmon": preload("res://scenes/dishes/salmon_dish.tscn"),
}

signal dish_spawned(dish_instance: Dish)


func _ready() -> void:
	pass


func _on_order_created(dish_name: String, flavors: Array) -> void:
	dish_queue.append(DishQueueItem.new(dish_name, flavors))
	check_queue()


func check_queue() -> void:
	if not can_spawn or dish_queue.size() < 1:
		return

	spawn_dish(dish_queue.pop_front())
	can_spawn = false
	await get_tree().create_timer(1.0).timeout
	can_spawn = true
	check_queue()


func spawn_dish(item: DishQueueItem) -> void:
	print("spawning dish: ", item.name)
	var dish_instance: Dish = dish_scenes[item.name].instantiate()
	dish_instance.required_flavors = item.flavors
	dish_instance.z_index = 3
	add_child(dish_instance)
	emit_signal("dish_spawned", dish_instance)
