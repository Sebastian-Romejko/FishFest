extends Area2D

signal clicked()

@onready var sprite = $sprite
@onready var button = $sprite/sub_viewport/button
@onready var door_sound = $door_sound
@onready var button_sound = $button_sound

func _on_body_entered(body):
	if body.name == "player":
		door_sound.play()
		button_sound.play()
		clicked.emit()
		button.play_clicked_animation()
		sprite.modulate.a = 0.5
