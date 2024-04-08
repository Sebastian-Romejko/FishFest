extends Node3D

signal hide_finished()

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")

func play_hide_animation():
	animation_player.speed_scale = 1.5
	animation_player.play("hide")
