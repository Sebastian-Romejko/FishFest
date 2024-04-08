extends Control

signal restart_clicked()

@onready var panel = $panel
@onready var button_sound = $button_sound

func _on_restart_button_pressed():
	restart_clicked.emit()
	button_sound.play()
	queue_free()
