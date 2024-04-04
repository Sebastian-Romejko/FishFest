extends CharacterBody2D

@export var move_speed: int = 20
@export var damage: int = 10
@export var push_power: int = 10

var player: Node2D

func _physics_process(delta):
	if player:
		look_at(player.position)
		var direction = position.direction_to(player.position)
		velocity = direction * move_speed
		move_and_slide()

func _on_vision_range_body_entered(body):
	if body.name == "player":
		player = body

func _on_vision_range_body_exited(body):
	if body.name == "player":
		player = null
