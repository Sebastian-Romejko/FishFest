extends Area2D

signal clicked()

@onready var sprite = $sprite
@onready var button = $sprite/sub_viewport/button

func _on_body_entered(body):
	if body.name == "player":
		clicked.emit()
		button.play_clicked_animation()
		sprite.modulate.a = 0.5
