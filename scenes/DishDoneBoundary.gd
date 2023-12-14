extends Area2D


func _on_area_entered(maybe_dish: Area2D) -> void:
	if maybe_dish is Dish:
		maybe_dish.destroy()
