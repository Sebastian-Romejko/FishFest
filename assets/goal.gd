extends Node2D

signal reached()

@onready var fish_goal = $fish_goal
@onready var happy_sound = $happy_sound

func _on_area_3d_body_entered(body):
	if body.name == "player":
		reached.emit()

func play_happy_animation(goal_height: int):
	happy_sound.play()
	fish_goal.play_happy_animation(goal_height)

func _on_happy_sound_finished():
	happy_sound.play()
