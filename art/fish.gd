extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")

func play_swim_animation():
	animation_player.play("swim")
	
func play_idle_animation():
	animation_player.play("idle")
	
