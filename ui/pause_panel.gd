extends Control

signal resume_clicked()
signal retry_clicked()
signal menu_clicked()

func _on_resume_button_pressed():
	resume_clicked.emit()
	queue_free()

func _on_menu_button_pressed():
	menu_clicked.emit()
	queue_free()
	
func _on_retry_button_pressed():
	retry_clicked.emit()
	queue_free()
