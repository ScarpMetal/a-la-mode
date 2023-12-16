extends Node2D

var order_container_scene := preload("res://scenes/ui/order_container.tscn")

var displayed_orders: Array[OrderContainer] = []
var next_orders_queue: Array[OrderContainer] = []
var max_orders_displayed := 3


func _on_order_created(dish_name: String, flavors: Array[String]) -> void:
	var order_container: OrderContainer = order_container_scene.instantiate()
	order_container.dish_name = dish_name
	order_container.flavors = flavors
	order_container.position = Vector2(0, -500)
	next_orders_queue.append(order_container)
	if not len(displayed_orders) >= max_orders_displayed:
		process_order_displays()


func process_order_displays() -> void:
	if len(displayed_orders) == max_orders_displayed:
		var first_order: OrderContainer = displayed_orders.pop_front()
		(
			create_tween()
			. tween_property(first_order, "position", Vector2(0, first_order.position.y - 500), 1)
			. set_trans(Tween.TRANS_SPRING)
			. connect("finished", func() -> void: first_order.queue_free())
		)

	for index in range(len(displayed_orders)):
		var order := displayed_orders[index]
		(
			create_tween()
			. tween_property(order, "position", Vector2(order.position.x - 250, 0), 1)
			. set_trans(Tween.TRANS_SPRING)
		)

	if len(next_orders_queue) > 0:
		var incoming_order: OrderContainer = next_orders_queue.pop_front()
		displayed_orders.append(incoming_order)
		create_tween().tween_property(incoming_order, "position", Vector2.ZERO, 1).set_trans(
			Tween.TRANS_SPRING
		)
		add_child(incoming_order)

func dish_removed() -> void:
	var first_order: OrderContainer = displayed_orders.pop_front()
	(
		create_tween()
		. tween_property(first_order, "position", Vector2(0, first_order.position.y - 500), 1)
		. set_trans(Tween.TRANS_SPRING)
		. connect("finished", func() -> void: first_order.queue_free())
	)
	for index in range(len(displayed_orders)):
		var order := displayed_orders[index]
		(
			create_tween()
			. tween_property(order, "position", Vector2(order.position.x - 250, 0), 1)
			. set_trans(Tween.TRANS_SPRING)
		)
	if len(next_orders_queue) > 0:
		var incoming_order: OrderContainer = next_orders_queue.pop_front()
		displayed_orders.append(incoming_order)
		create_tween().tween_property(incoming_order, "position", Vector2.ZERO, 1).set_trans(
			Tween.TRANS_SPRING
		)
		add_child(incoming_order)



func _on_dish_failed() -> void:
	dish_removed()


func _on_dish_completed() -> void:
	dish_removed()
