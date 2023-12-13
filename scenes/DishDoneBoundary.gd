extends Area2D


func _on_body_entered(maybe_dish: Node2D) -> void:
	if maybe_dish is Dish:
		maybe_dish.destroy()
