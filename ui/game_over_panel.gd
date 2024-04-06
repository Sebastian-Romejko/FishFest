extends Control

signal restart_clicked()

@onready var panel = $panel

func _on_restart_button_pressed():
	restart_clicked.emit()
	queue_free()
