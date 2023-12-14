extends Area2D


func _on_area_entered(maybe_scoop: Area2D) -> void:
	if maybe_scoop is FallingScoop:
		maybe_scoop.queue_free()
