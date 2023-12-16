extends Node

var difficulty_level: int = 0
var speed1Player: AudioStreamPlayer
var speed2Player: AudioStreamPlayer
var speed3Player: AudioStreamPlayer
var speed4Player: AudioStreamPlayer
var speed1IndoorPlayer: AudioStreamPlayer
var speed2IndoorPlayer: AudioStreamPlayer
var speed3IndoorPlayer: AudioStreamPlayer
var speed4IndoorPlayer: AudioStreamPlayer
var activePlayer: AudioStreamPlayer
var speedPlayers: Array[AudioStreamPlayer]
var speedIndoorPlayers: Array[AudioStreamPlayer]


func _ready() -> void:
	speed1Player = $Speed1Player
	speed2Player = $Speed2Player
	speed3Player = $Speed3Player
	speed4Player = $Speed4Player
	speedPlayers = [speed1Player, speed2Player, speed3Player, speed4Player]
	speed1IndoorPlayer = $Speed1IndoorPlayer
	speed2IndoorPlayer = $Speed2IndoorPlayer
	speed3IndoorPlayer = $Speed3IndoorPlayer
	speed4IndoorPlayer = $Speed4IndoorPlayer
	speedIndoorPlayers = [speed1IndoorPlayer, speed2IndoorPlayer, speed3IndoorPlayer, speed4IndoorPlayer]
	
	activePlayer = speed1IndoorPlayer
	start_player()


func start_player() -> void:
	activePlayer.play()


func _on_order_creator_difficulty_changed(new_difficulty_level: int) -> void:
	difficulty_level = new_difficulty_level
	swapActivePlayer(speedIndoorPlayers[difficulty_level])


func swapActivePlayer(nextPlayer: AudioStreamPlayer) -> void:
	var playback_position: float = activePlayer.get_playback_position()
	activePlayer.stop()
	nextPlayer.play(playback_position)
	activePlayer = nextPlayer


func _on_game_manager_toggle_game_paused(is_paused: bool) -> void:
	if (is_paused):
		swapActivePlayer(speedPlayers[difficulty_level])
	else:
		swapActivePlayer(speedIndoorPlayers[difficulty_level])
