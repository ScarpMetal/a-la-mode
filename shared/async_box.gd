class_name AsyncBox
extends RefCounted

signal _result_signal(result: Variant)
		
static func from_signal(p_signal: Signal) -> Callable:
	return func(resolve: Callable) -> void:
		resolve.call(await p_signal)

static func all_boxes(boxes: Array[AsyncBox]) -> Array[Variant]:
	var result_values: Array[Variant] = []
	for box in boxes:
		result_values.append(await box.result)
	return result_values
		
var _resolved: bool = false
var _result_value: Variant = null
		
var result: Variant:
	get:
		return (
			_result_value if _resolved 
			else await _result_signal
		)
		
func _init(callable: Callable) -> void:
	callable.call_deferred(_on_resolved)
		
func _on_resolved(result_value: Variant = null) -> void:
	_result_value = result_value
	_resolved = true
	_result_signal.emit(_result_value)