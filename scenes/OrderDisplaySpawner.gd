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

func all_promises(promises: Array[Promise]) -> Array[Variant]:
	var result_values: Array[Variant] = []
	for promise in promises:
		result_values.append(await promise.completed)
	return result_values

class Promise extends RefCounted:
	signal _completed_signal(result: Variant)
	var _resolved: bool = false
	var _result_value: Variant = null

	var completed: Variant:
		get:
			return _completed_signal
			# if not _resolved:
			# 	return _completed_signal
			# else:
			# return _result_value

	func _init(init: Variant) -> void:
		if init is Callable:
			_completed_signal.connect(_on_completed)
			init.call(_completed_signal)
		elif init is Signal:
			init.connect(_on_completed)

	func _on_completed(result: Variant) -> void:
		_result_value = result
		_resolved = true

func process_operation_queue() -> void:
	if len(operation_queue) == 0:
		return

	var operation_queue_item: Dictionary = operation_queue.pop_front()
	var operation: String = operation_queue_item.get("operation")
	var operation_order_container: OrderContainer = operation_queue_item.get("order_container")

	if operation == "remove":
		var tween_promises: Array[Promise] = []
		var order_container_index := find_custom(
			func(order_container: OrderContainer) -> bool: 
				return order_container.order.id == operation_order_container.order.id,
			active_order_containers
		)
		if order_container_index != -1:
			if len(active_order_containers) > max_orders_displayed:
				for i in range(order_container_index + 1, min(max_orders_displayed, len(active_order_containers))):
					(
						tween_promises.append(Promise.new(create_tween()
						. tween_property(active_order_containers[i], "position", Vector2(active_order_containers[i].position.x - 250, 0), 1)
						. set_trans(Tween.TRANS_SPRING)
						. finished))
					)

			if len(active_order_containers) > max_orders_displayed:
				var next_order_container: OrderContainer = active_order_containers[max_orders_displayed]
				tween_promises.append(Promise.new(create_tween()
					.tween_property(next_order_container, "position", Vector2.ZERO, 1)
					.set_trans(Tween.TRANS_SPRING)
					.finished))

			var order_container: OrderContainer = active_order_containers.pop_at(order_container_index)

			var tween_and_free := func(completed_signal: Signal) -> void:
				(
					await create_tween()
					. tween_property(
						order_container,
						"position",
						Vector2(order_container.position.x, -500), 1
					)
					. set_trans(Tween.TRANS_SPRING)
					. finished
				)
				print("freeing")
				order_container.queue_free()
				completed_signal.emit()

			var promise: Promise = Promise.new(tween_and_free)
			tween_promises.append(promise)

		await all_promises(tween_promises)


	if operation == "add":
		var tween_promises: Array[Promise] = []
		if len(active_order_containers) < max_orders_displayed:
			for order_container in active_order_containers:
				tween_promises.append(Promise.new(create_tween()
					. tween_property(order_container, "position", Vector2(order_container.position.x - 250, 0), 1)
					. set_trans(Tween.TRANS_SPRING)
					. finished))

			tween_promises.append(Promise.new(create_tween()
				.tween_property(operation_order_container, "position", Vector2.ZERO, 1)
				.set_trans(Tween.TRANS_SPRING)
				.finished))

		active_order_containers.append(operation_order_container)
		await all_promises(tween_promises)

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
