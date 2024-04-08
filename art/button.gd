extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")

func play_clicked_animation():
	animation_player.play("clicked")
