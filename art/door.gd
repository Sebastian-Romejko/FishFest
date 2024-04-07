extends Sprite2D

@export var button: Area2D

func _ready():
	button.clicked.connect(open_door)
	modulate = button.modulate

func open_door():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(100, 0), 2)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "scale", Vector2(0, 0), 2)
	tween.play()
	tween2.play()
	await get_tree().create_timer(2).timeout
	queue_free()
