extends Control

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")

func _on_quit_pressed() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.location.href='https://scarpmetal.itch.io/a-la-mode'")
	else:
		get_tree().quit()
