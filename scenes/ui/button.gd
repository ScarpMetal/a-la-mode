extends Button

var pressPlayer: AudioStreamPlayer
var hoverPlayer: AudioStreamPlayer
var leavePlayer: AudioStreamPlayer

func _ready() -> void:
	pressPlayer = $PressPlayer
	hoverPlayer = $HoverPlayer
	leavePlayer = $LeavePlayer

func _on_button_down() -> void:
	pressPlayer.play()

func _on_button_hover() -> void:
	hoverPlayer.play()

func _on_mouse_exited() -> void:
	leavePlayer.play()
