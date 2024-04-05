extends Node2D

signal reached()

func _on_area_3d_body_entered(body):
	if body.name == "player":
		reached.emit()
