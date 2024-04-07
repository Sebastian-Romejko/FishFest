extends Control

signal paused_pressed()

@onready var progress_bar = $control/center_container/texture_progress_bar

func set_energy(energy):
	progress_bar.value = energy

func _on_pause_pressed():
	paused_pressed.emit()
