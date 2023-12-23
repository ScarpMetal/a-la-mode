extends Node2D

var order_container_scene := preload("res://scenes/ui/order_container.tscn")
var max_orders_displayed := 3

var active_order_displays: Array[OrderContainer] = []
var operation_queue: Array[Dictionary] = []

func find_custom(method: Callable, arr: Array) -> int:
	for index: int in range(arr.size()):
		if method.call(arr[index]):
			return index
	return -1

func remove_custom(method: Callable, arr: Array[Variant]) -> Variant:
	for index: int in range(arr.size()):
		if method.call(arr[index]):
			return arr.pop_at(index)
	return null

func all_signals(coroutines: Array[Signal]) -> Array[Variant]:
	var result_values: Array[Variant] = []
	for coroutine in coroutines:
		result_values.append(await coroutine)
	return result_values


func process_operation_queue() -> void:
	if len(operation_queue) == 0:
		return

	var operation_queue_item: Dictionary = operation_queue.pop_front()
	var operation: String = operation_queue_item.get("operation")
	var order: OrderCreator.Order = operation_queue_item.get("order")

	if operation == "remove":
		var tween_signals: Array[Signal] = []
		var order_display_index := find_custom(
			func(order_display: OrderContainer) -> bool: return order.id == order_display.order.id,
			active_order_displays
		)
		if order_display_index != -1:
			for i in range(order_display_index + 1, min(max_orders_displayed - 1, len(active_order_displays))):
				(
					tween_signals.append(create_tween()
					. tween_property(active_order_displays[i], "position", Vector2(active_order_displays[i].position.x - 250, 0), 1)
					. set_trans(Tween.TRANS_SPRING)
					. finished)
				)

			var order_display: OrderContainer = active_order_displays.pop_at(order_display_index)
			var tween_and_free := func() -> void:
				(
					await create_tween()
					. tween_property(
						order_display,
						"position",
						Vector2(0, order_display.position.y - 500), 1
					)
					. set_trans(Tween.TRANS_SPRING)
					. finished
				)
				order_display.queue_free()

			tween_signals.append(tween_and_free.call())

		await all_signals(tween_signals)

	if operation == "add":
		var tween_signals: Array[Signal] = []
		if len(active_order_displays) < max_orders_displayed:
			for order_display in active_order_displays:
				tween_signals.append(create_tween()
				. tween_property(order_display, "position", Vector2(order_display.position.x - 250, 0), 1)
				. set_trans(Tween.TRANS_SPRING)
				. finished)

			tween_signals.append(create_tween()
				.tween_property(order, "position", Vector2.ZERO, 1)
				.set_trans(Tween.TRANS_SPRING)
				.finished)

		active_order_displays.append(order)
		await all_signals(tween_signals)

	process_operation_queue()


func queue_add_order(order: OrderContainer) -> void:
	operation_queue.append({"operation": "add", order: order})
	process_operation_queue()


func queue_remove_order(order: OrderContainer) -> void:
	operation_queue.append({"operation": "remove", order: order})
	process_operation_queue()

func _on_order_created(order: OrderCreator.Order) -> void:
	var order_container: OrderContainer = order_container_scene.instantiate()
	order_container.order = order
	order_container.position = Vector2(0, -500)
	print("CREATED!")
	add_child(order_container)
	queue_add_order(order_container)

func _on_dish_completed(_success: bool, order_id: int) -> void:
	var index := find_custom(
		func(order_display: OrderContainer) -> bool: return order_id == order_display.order.id,
		active_order_displays
	)
	if index == -1:
		return
	queue_remove_order(active_order_displays[index])
