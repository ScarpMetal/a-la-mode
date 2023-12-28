class_name Utils

static func map_value(
	value: float, from_min: float, from_max: float, to_min: float, to_max: float
) -> float:
	var clamped_value := clampf(value, from_min, from_max)
	return to_min + (to_max - to_min) * ((clamped_value - from_min) / (from_max - from_min))