extends Control

@onready var star = $SubViewportContainer/sub_viewport/star

func set_enable():
	modulate = Color(1, 1, 1)
	star.play_happy_animation()
