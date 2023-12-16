extends Control

var intro_player: AudioStreamPlayer
var loop_player: AudioStreamPlayer

func _ready() -> void:
	intro_player = $IntroPlayer
	loop_player = $LoopPlayer
	start_intro_player()

func start_intro_player() -> void:
	intro_player.play()
	
func _on_intro_player_finished() -> void:
	loop_player.play()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.location.href='https://scarpmetal.itch.io/a-la-mode'")
	else:
		get_tree().quit()

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")
