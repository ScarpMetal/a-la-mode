extends Control

@export var game_manager : GameManager

func _ready() -> void:
	print("ready")
	hide()
	game_manager.connect("toggle_game_paused", _on_plating_screen_toggle_game_paused)

func _on_plating_screen_toggle_game_paused(is_paused: bool) -> void:
	if is_paused:
		show()
	else:
		hide()

func _on_resume_pressed() -> void:
	game_manager.game_paused = false
	pass

func _on_main_menu_pressed() -> void:
	game_manager.game_paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
