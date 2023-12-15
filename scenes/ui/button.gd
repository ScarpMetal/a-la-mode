extends Button

var buttonPressPlayer: AudioStreamPlayer
var buttonHoverPlayer: AudioStreamPlayer

func _ready() -> void:
	buttonPressPlayer = $ButtonPressPlayer
	buttonHoverPlayer = $ButtonHoverPlayer

func _on_button_down() -> void:
	buttonPressPlayer.play()
	
func _on_button_hover() -> void:
	buttonHoverPlayer.play()
