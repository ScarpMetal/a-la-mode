extends Node2D

var dish_queue: Array[String] = []
var can_spawn: bool = true
var dish_scenes: Dictionary = {
	"steak": preload("res://scenes/dishes/steak_dish.tscn"),
	"veggies": preload("res://scenes/dishes/veggies_dish.tscn"),
	"salmon": preload("res://scenes/dishes/salmon_dish.tscn"),
}


func _ready() -> void:
	pass


func _on_order_created(dish_name: String, _flavors: Array) -> void:
	dish_queue.append(dish_name)
	check_queue()


func check_queue() -> void:
	if not can_spawn or dish_queue.size() < 1:
		return

	spawn_dish(dish_queue.pop_front())
	can_spawn = false
	await get_tree().create_timer(1.0).timeout
	can_spawn = true
	check_queue()


func spawn_dish(dish_name: String) -> void:
	print("spawning dish: ", dish_name)
	var dish_instance: CharacterBody2D = dish_scenes[dish_name].instantiate()
	add_child(dish_instance)
