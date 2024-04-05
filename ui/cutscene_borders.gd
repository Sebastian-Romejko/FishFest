extends Control

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property($upper_border, "custom_minimum_size.y", 30, 2)
	tween.tween_property($bottom_border, "custom_minimum_size.y", 30, 2)
