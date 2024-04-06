extends Node3D

signal attack_finished()

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")

func play_swim_animation():
	animation_player.play("swim")
	
func play_idle_animation():
	animation_player.play("idle")
	
func play_attack_animation():
	animation_player.play("attack")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		attack_finished.emit()
