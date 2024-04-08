extends Control

signal resume_clicked()
signal retry_clicked()
signal menu_clicked()

@onready var button_sound = $button_sound

func _on_resume_button_pressed():
	button_sound.play()
	resume_clicked.emit()
	queue_free()

func _on_menu_button_pressed():
	button_sound.play()
	menu_clicked.emit()
	queue_free()
	
func _on_retry_button_pressed():
	button_sound.play()
	retry_clicked.emit()
	queue_free()
