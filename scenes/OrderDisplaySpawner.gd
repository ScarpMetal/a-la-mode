extends Node2D

var order_container_scene := preload("res://scenes/ui/order_container.tscn")
var max_orders_displayed := 3

var active_order_containers: Array[OrderContainer] = []
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

class Promise extends RefCounted:
	signal _completed_signal(result: Variant)
	var _completed_value: Variant = null

	var completed: Variant:
		get:
			if _completed_value != null:
				return _completed_value
			else:
				return _completed_signal

	func _init(async_func: Callable) -> void:
		var result: Variant = await async_func.call()
		_completed_signal.emit(result)


func process_operation_queue() -> void:
	if len(operation_queue) == 0:
		return

	var operation_queue_item: Dictionary = operation_queue.pop_front()
	var operation: String = operation_queue_item.get("operation")
	var operation_order_container: OrderContainer = operation_queue_item.get("order_container")

	if operation == "remove":
		var tween_signals: Array[Signal] = []
		var order_container_index := find_custom(
			func(order_container: OrderContainer) -> bool: 
				return order_container.order.id == operation_order_container.order.id,
			active_order_containers
		)
		if order_container_index != -1:
			if len(active_order_containers) > max_orders_displayed:
				for i in range(order_container_index + 1, min(max_orders_displayed, len(active_order_containers))):
					(
						tween_signals.append(create_tween()
						. tween_property(active_order_containers[i], "position", Vector2(active_order_containers[i].position.x - 250, 0), 1)
						. set_trans(Tween.TRANS_SPRING)
						. finished)
					)

			if len(active_order_containers) > max_orders_displayed:
				var next_order_container: OrderContainer = active_order_containers[max_orders_displayed]
				tween_signals.append(create_tween()
					.tween_property(next_order_container, "position", Vector2.ZERO, 1)
					.set_trans(Tween.TRANS_SPRING)
					.finished)

			var order_container: OrderContainer = active_order_containers.pop_at(order_container_index)
			# tween_signals.append(create_tween()
			# . tween_property(
			# 	order_container,
			# 	"position",
			# 	Vector2(order_container.position.x, -500), 1
			# )
			# . set_trans(Tween.TRANS_SPRING)
			# . finished)

			var tween_and_free := func() -> void:
				(
					await create_tween()
					. tween_property(
						order_container,
						"position",
						Vector2(0, order_container.position.y - 500), 1
					)
					. set_trans(Tween.TRANS_SPRING)
					. finished
				)
				order_container.queue_free()

			var promise := Promise.new(tween_and_free)

			# tween_signals.append(tween_and_free.)

		await all_signals(tween_signals)

	if operation == "add":
		var tween_signals: Array[Signal] = []
		if len(active_order_containers) < max_orders_displayed:
			for order_container in active_order_containers:
				tween_signals.append(create_tween()
					. tween_property(order_container, "position", Vector2(order_container.position.x - 250, 0), 1)
					. set_trans(Tween.TRANS_SPRING)
					. finished)

			tween_signals.append(create_tween()
				.tween_property(operation_order_container, "position", Vector2.ZERO, 1)
				.set_trans(Tween.TRANS_SPRING)
				.finished)

		active_order_containers.append(operation_order_container)
		await all_signals(tween_signals)

	process_operation_queue()


func queue_add_order(order_container: OrderContainer) -> void:
	operation_queue.append({"operation": "add", "order_container": order_container})
	process_operation_queue()


func queue_remove_order(order_container: OrderContainer) -> void:
	operation_queue.append({"operation": "remove", "order_container": order_container})
	process_operation_queue()

func _on_order_created(order: OrderCreator.Order) -> void:
	var order_container: OrderContainer = order_container_scene.instantiate()
	order_container.order = order
	order_container.position = Vector2(0, -500)
	add_child(order_container)
	queue_add_order(order_container)

func _on_dish_completed(_success: bool, order_id: int) -> void:
	var index := find_custom(
		func(order_container: OrderContainer) -> bool: return order_id == order_container.order.id,
		active_order_containers
	)
	if index == -1:
		return
	queue_remove_order(active_order_containers[index])
