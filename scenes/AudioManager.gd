extends Node

var speed1Player: AudioStreamPlayer
var speed2Player: AudioStreamPlayer
var speed3Player: AudioStreamPlayer
var speed4Player: AudioStreamPlayer
var speed1IndoorPlayer: AudioStreamPlayer
var speed2IndoorPlayer: AudioStreamPlayer
var speed3IndoorPlayer: AudioStreamPlayer
var speed4IndoorPlayer: AudioStreamPlayer
var activePlayer: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed1Player = $Speed1Player
	speed2Player = $Speed2Player
	speed3Player = $Speed3Player
	speed4Player = $Speed4Player
	speed1IndoorPlayer = $Speed1IndoorPlayer
	speed2IndoorPlayer = $Speed2IndoorPlayer
	speed3IndoorPlayer = $Speed3IndoorPlayer
	speed4IndoorPlayer = $Speed4IndoorPlayer
	activePlayer = speed1Player
	start_player()

func start_player() -> void:
	activePlayer.play()

func _on_order_creator_difficulty_changed(new_difficulty_level: int) -> void:
	if new_difficulty_level == 0:
		swapActivePlayer(speed1Player)
	elif new_difficulty_level == 1:
		swapActivePlayer(speed2Player)
	elif new_difficulty_level == 2:
		swapActivePlayer(speed3Player)
	else:
		swapActivePlayer(speed4Player)

func swapActivePlayer(nextPlayer: AudioStreamPlayer) -> void:
	var playback_position: float = activePlayer.get_playback_position()
	activePlayer.stop()
	nextPlayer.play(playback_position)
	activePlayer = nextPlayer
