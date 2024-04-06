extends Control

@export var border_height: int = 20

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property($upper_border, "custom_minimum_size", Vector2(0, border_height), 1)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($bottom_border, "custom_minimum_size", Vector2(0, border_height), 1)
	tween.play()
	tween2.play()
