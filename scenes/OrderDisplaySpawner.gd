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

func all_boxes(boxes: Array[AsyncBox]) -> Array[Variant]:
	var result_values: Array[Variant] = []
	for box in boxes:
		result_values.append(await box.result)
	return result_values

class AsyncBox extends RefCounted:
	signal _result_signal(result: Variant)
		
	static func from_signal(p_signal: Signal) -> Callable:
		return func(resolve: Callable) -> void:
			resolve.call(await p_signal)
		
	var _resolved: bool = false
	var _result_value: Variant = null
		
	var result: Variant:
		get:
			return (
				_result_value if _resolved 
				else _result_signal
			)
		
	func _init(callable: Callable) -> void:
		callable.call_deferred(_on_resolved)
		
	func _on_resolved(result_value: Variant = null) -> void:
		_result_value = result_value
		_resolved = true
		_result_signal.emit(_result_value)

func process_operation_queue() -> void:
	if len(operation_queue) == 0:
		return

	var operation_queue_item: Dictionary = operation_queue.pop_front()
	var operation: String = operation_queue_item.get("operation")
	var operation_order_container: OrderContainer = operation_queue_item.get("order_container")

	if operation == "remove":
		var async_deps: Array[AsyncBox] = []
		var order_container_index := find_custom(
			func(order_container: OrderContainer) -> bool: 
				return order_container.order.id == operation_order_container.order.id,
			active_order_containers
		)
		if order_container_index != -1:
			if len(active_order_containers) > max_orders_displayed:
				for i in range(order_container_index + 1, min(max_orders_displayed, len(active_order_containers))):
					(
						async_deps.append(AsyncBox.new(AsyncBox.from_signal(create_tween()
						. tween_property(active_order_containers[i], "position", Vector2(active_order_containers[i].position.x - 250, 0), 1)
						. set_trans(Tween.TRANS_SPRING)
						. finished)))
					)

			if len(active_order_containers) > max_orders_displayed:
				var next_order_container: OrderContainer = active_order_containers[max_orders_displayed]
				async_deps.append(AsyncBox.new(AsyncBox.from_signal(create_tween()
					.tween_property(next_order_container, "position", Vector2.ZERO, 1)
					.set_trans(Tween.TRANS_SPRING)
					.finished)))

			var order_container: OrderContainer = active_order_containers.pop_at(order_container_index)

			async_deps.append(AsyncBox.new(func(resolve: Callable) -> void:
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
				order_container.queue_free()
				resolve.call()
			))

		await all_boxes(async_deps)


	if operation == "add":
		var async_deps: Array[AsyncBox] = []
		if len(active_order_containers) < max_orders_displayed:
			for order_container in active_order_containers:
				async_deps.append(AsyncBox.new(AsyncBox.from_signal(create_tween()
					. tween_property(order_container, "position", Vector2(order_container.position.x - 250, 0), 1)
					. set_trans(Tween.TRANS_SPRING)
					. finished)))

			async_deps.append(AsyncBox.new(AsyncBox.from_signal(create_tween()
				.tween_property(operation_order_container, "position", Vector2.ZERO, 1)
				.set_trans(Tween.TRANS_SPRING)
				.finished)))

		active_order_containers.append(operation_order_container)
		await all_boxes(async_deps)

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
