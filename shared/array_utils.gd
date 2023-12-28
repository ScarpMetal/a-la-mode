class_name ArrayUtils

static func find_custom(callable: Callable, arr: Array) -> int:
	for index: int in range(arr.size()):
		if callable.call(arr[index]):
			return index
	return -1

static func remove_func(callable: Callable, arr: Array[Variant]) -> Variant:
	for index: int in range(arr.size()):
		if callable.call(arr[index]):
			return arr.pop_at(index)
	return null
