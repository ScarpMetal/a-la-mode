extends Node

var buckets: Dictionary

@export var flavors: Array[String]:
	get:
		return flavors
	set(value):
		var remaining_flavors: Array[String] = Array(flavors)
		flavors = value
		var num_flavors: int = flavors.size()
		var positions: Array[Vector2] = get_bucket_positions(num_flavors)
		# Set next flavor positions
		for i in num_flavors:
			var flavor: String = flavors[i]
			var remaining_flavor_index: int = remaining_flavors.find(flavor)
			if remaining_flavor_index > -1:
				remaining_flavors.remove_at(remaining_flavor_index)
			var bucket: Bucket = buckets.get(flavor)
			var next_position: Vector2 = positions[i]
			bucket.position = next_position
		# remove unused flavors
		for flavor in remaining_flavors:
			var bucket: Bucket = buckets.get(flavor)
			bucket.position = bucket.position + Vector2(0, 600)


func _ready() -> void:
	buckets = {
		"vanilla": $VanillaBucket,
		"pistachio": $PistachioBucket,
		"strawberry": $StrawberryBucket,
		"chocolate": $ChocolateBucket,
		"blueberry": $BlueberryBucket
	}
	flavors = ["vanilla", "chocolate"]


func get_bucket_positions(num_buckets: int) -> Array[Vector2]:
	var s: Vector2 = get_viewport().get_size()
	var bcw: float = 900
	var bw: float = 340
	var bh: float = 440
	if num_buckets <= 0 or num_buckets > 5:
		assert("Should have between 1 and 5 buckets")

	var positions: Array[Vector2] = []
	if num_buckets >= 1:
		positions.push_front(Vector2(1920 - bw - bcw * .4, 1080 - bh * .63))
	if num_buckets >= 2:
		positions.push_front(Vector2(1920 - bw * 2 - bcw * .4, 1080 - bh * .63))
	if num_buckets >= 3:
		positions.push_front(Vector2(1920 - bw * 3 - bcw * .4, 1080 - bh * .63))
	if num_buckets >= 4:
		positions.push_front(Vector2(1920 - bw * 4 - bcw * .4, 1080 - bh * .63))
	if num_buckets >= 5:
		positions.push_front(Vector2(1920 - bw * 5 - bcw * .4, 1080 - bh * .63))
	return positions


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		var all_flavors: Array[String] = [
			"vanilla", "chocolate", "blueberry", "strawberry", "pistachio"
		]
		var num_to_remove: int = randi_range(0, 4)
		for i in num_to_remove:
			var index_to_remove: int = randi_range(0, all_flavors.size() - 1)
			all_flavors.remove_at(index_to_remove)
		flavors = all_flavors
