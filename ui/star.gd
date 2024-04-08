extends Control

@onready var star = $SubViewportContainer/sub_viewport/star
@onready var sound = $sound

func set_enable():
	sound.play()
	modulate = Color(1, 1, 1)
	star.play_happy_animation()
