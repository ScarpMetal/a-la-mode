extends Node

@export var dish_names: Array[String] = ["steak", "veggies", "salmon"]
@export var ice_cream_flavor_names: Array[String] = ["vanilla", "chocolate", "strawberry"]
@export var time_to_first_order_sec: int = 3

const DIFFICULTY_INTERVALS_SEC: Array[int] = [10, 60, 600]

var time_since_start := 0.0
var difficulty_level := 0
var order_timer := Timer.new()

signal order_created(dish_name: String, flavors: Array[String])


func _ready() -> void:
	add_child(order_timer)
	order_timer.connect("timeout", _on_order_timeout)


func _process(delta: float) -> void:
	if order_timer.paused or order_timer.is_stopped():
		return

	time_since_start += delta
	update_difficulty_level()


func start() -> void:
	time_since_start = 0.0
	difficulty_level = 0
	order_timer.start(time_to_first_order_sec)


func pause() -> void:
	order_timer.paused = true


func resume() -> void:
	order_timer.paused = false


func stop() -> void:
	order_timer.stop()


func update_difficulty_level() -> void:
	for i in range(len(DIFFICULTY_INTERVALS_SEC)):
		if time_since_start < DIFFICULTY_INTERVALS_SEC[i]:
			difficulty_level = i
			break


func _on_order_timeout() -> void:
	generate_order()
	order_timer.start(get_time_to_next_order())


func get_time_to_next_order() -> int:
	match difficulty_level:
		0:
			return randi_range(4, 6)
		1:
			return randi_range(3, 5)
		2:
			return randi_range(2, 4)
		3:
			return randi_range(1, 3)
	return 1


func generate_order() -> void:
	var dish: String = dish_names[randi_range(0, dish_names.size() - 1)]
	var max_flavors: int = difficulty_level + 1
	var flavors: Array[String] = []
	for i in randi_range(1, max_flavors):
		flavors.append(ice_cream_flavor_names[randi_range(0, ice_cream_flavor_names.size() - 1)])

	print("created order: ", dish, flavors)
	emit_signal("order_created", dish, flavors)
