extends Area2D

class_name Dish

@export var speed := 200.0
@export var required_flavors: Array[String] = []

signal ice_cream_hit(hit_flavor: String, required_flavors: Array[String])
signal destroyed(current_flavors: Array[String], required_flavors: Array[String])

var current_flavors: Array[String] = []


func _physics_process(delta: float) -> void:
	position += Vector2(speed * delta, 0)


func destroy() -> void:
	queue_free()
	emit_signal("destroyed", current_flavors, required_flavors)


# temp stick the scoop to the dish
func stick_on(scoop: FallingScoop) -> void:
	scoop.monitorable = false
	scoop.freeze()
	scoop.call_deferred("reparent", self)


func _on_area_entered(maybe_scoop: Area2D) -> void:
	# shouldn't have to do this. It's a likely bug
	if not maybe_scoop.monitorable:
		return
	if maybe_scoop is FallingScoop:
		if not maybe_scoop.can_hit_dish:
			return

		call_deferred("stick_on", maybe_scoop)

		var flavor: String = maybe_scoop.get_node("ScoopSprite").flavor
		current_flavors.append(flavor)
		emit_signal("ice_cream_hit", flavor, required_flavors)
