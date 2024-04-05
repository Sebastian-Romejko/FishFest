extends CharacterBody2D

@onready var vision_range_shape = $vision_range/collision_shape

@export var move_speed: int = 15
@export var vision_range: int = 60
@export var damage: int = 10
@export var push_power: int = 50

var player: Node2D

func _ready():
	vision_range_shape.shape.radius = vision_range

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

func _on_hit_box_body_entered(body):
	if body.name == "player":
		body.push_back(position, push_power)
