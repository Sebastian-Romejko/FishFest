extends Sprite2D


func _on_area_2d_body_entered(body):
	if body.name == "player":
		body.gain_superpower()
		queue_free()