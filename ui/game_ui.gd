extends Control

@onready var progress_bar = $center_container/texture_progress_bar

func set_energy(energy):
	progress_bar.value = energy
