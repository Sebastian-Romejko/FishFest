extends Area2D

signal clicked()

@onready var sprite = $sprite

func _on_body_entered(body):
	if body.name == "player":
		clicked.emit()
		sprite.modulate.a = 0.5
