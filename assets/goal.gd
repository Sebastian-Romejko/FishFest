extends Node2D

signal reached()

@onready var fish_goal = $fish_goal

func _on_area_3d_body_entered(body):
	if body.name == "player":
		reached.emit()

func play_happy_animation(goal_height: int):
	fish_goal.play_happy_animation(goal_height)
