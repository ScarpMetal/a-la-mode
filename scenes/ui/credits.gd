extends Control


func _on_back_pressed() -> void:
	back()


func _input(event: InputEvent) -> void:
	if event.is_action("back"):
		back()


func back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
