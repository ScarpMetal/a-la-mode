extends TextureRect

class_name DishesCompleteHUD

@onready var out_of_label: Label = $CenterContainer.get_node("HBoxContainer/OutOf")
@onready var num_label: Label = $CenterContainer.get_node("HBoxContainer/Number")


func set_out_of_value(value: int) -> void:
	out_of_label.text = str(value)


func set_num_label_value(value: int) -> void:
	num_label.text = str(value)
