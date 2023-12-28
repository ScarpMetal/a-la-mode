extends Node2D

var order_container_scene := preload("res://scenes/ui/order_container.tscn")
var max_orders_displayed := 3

var active_order_containers: Array[OrderContainer] = []
var operation_queue: Array[Dictionary] = []

func remove_order_container(order_container: OrderContainer) -> void:
	var async_deps: Array[AsyncBox] = []
	var order_container_index := ArrayUtils.find_custom(
		func(active_order_container: OrderContainer) -> bool: 
			return active_order_container.order.id == order_container.order.id,
		active_order_containers
	)
	if order_container_index == -1:
		return

	if len(active_order_containers) > max_orders_displayed:
		for i in range(order_container_index + 1, min(max_orders_displayed, len(active_order_containers))):
			(
				async_deps.append(AsyncBox.new(AsyncBox.from_signal(create_tween()
				. tween_property(active_order_containers[i], "position", Vector2(active_order_containers[i].position.x - 250, 0), 1)
				. set_trans(Tween.TRANS_SPRING)
				. finished)))
			)

		var next_order_container: OrderContainer = active_order_containers[max_orders_displayed]
		async_deps.append(AsyncBox.new(AsyncBox.from_signal(create_tween()
			.tween_property(next_order_container, "position", Vector2.ZERO, 1)
			.set_trans(Tween.TRANS_SPRING)
			.finished)))

	var removed_order_container: OrderContainer = active_order_containers.pop_at(order_container_index)

	async_deps.append(AsyncBox.new(func(resolve: Callable) -> void:
		(
			await create_tween()
			. tween_property(
				removed_order_container,
				"position",
				Vector2(removed_order_container.position.x, -500), 1
			)
			. set_trans(Tween.TRANS_SPRING)
			. finished
		)
		removed_order_container.queue_free()
		resolve.call()
	))

	await AsyncBox.all_boxes(async_deps)

func add_order_container(order_container: OrderContainer) -> void:
	add_child(order_container)
	var async_deps: Array[AsyncBox] = []
	if len(active_order_containers) < max_orders_displayed:
		for active_order_container in active_order_containers:
			async_deps.append(AsyncBox.new(AsyncBox.from_signal(create_tween()
				. tween_property(active_order_container, "position", Vector2(active_order_container.position.x - 250, 0), 1)
				. set_trans(Tween.TRANS_SPRING)
				. finished)))

		async_deps.append(AsyncBox.new(AsyncBox.from_signal(create_tween()
			.tween_property(order_container, "position", Vector2.ZERO, 1)
			.set_trans(Tween.TRANS_SPRING)
			.finished)))

	active_order_containers.append(order_container)
	await AsyncBox.all_boxes(async_deps)

func process_operation_queue() -> void:
	if len(operation_queue) == 0:
		return

	var operation_queue_item: Dictionary = operation_queue.pop_front()
	var operation: String = operation_queue_item.get("operation")
	var operation_order_container: OrderContainer = operation_queue_item.get("order_container")

	if operation == "remove":
		remove_order_container(operation_order_container)

	if operation == "add":
		add_order_container(operation_order_container)

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
	queue_add_order(order_container)

func _on_dish_completed(_success: bool, order_id: int) -> void:
	var index := ArrayUtils.find_custom(
		func(order_container: OrderContainer) -> bool: return order_id == order_container.order.id,
		active_order_containers
	)
	if index == -1:
		return
	queue_remove_order(active_order_containers[index])
