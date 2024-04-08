extends Control

signal paused_pressed()

@onready var progress_bar = $control/center_container/texture_progress_bar
@onready var button_sound = $button_sound

func set_energy(energy):
	progress_bar.value = energy

func _on_pause_pressed():
	button_sound.play()
	paused_pressed.emit()
