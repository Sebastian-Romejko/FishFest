extends CharacterBody2D

@onready var fish = $sprite/sub_viewport/fish_enemy_1
@onready var viewport = $sprite/sub_viewport
@onready var vision_range_shape = $vision_range/collision_shape

@export var move_speed: float = 5
@export var MAX_SPEED: int = 30
@export var vision_range: int = 60
@export var damage: int = 100
@export var push_power: int = 50

var player: Node2D
var attacking = false

func _ready():
	fish.play_idle_animation()
	vision_range_shape.shape.radius = vision_range

func _physics_process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	if player:
		look_at(player.position)
		var direction = position.direction_to(player.position)
		velocity += direction * move_speed / 10
		limit_to_max_speed()
		move_and_slide()
		
		if !attacking:
			fish.play_swim_animation()
		
func limit_to_max_speed():
	velocity.x = min(MAX_SPEED, velocity.x) if velocity.x > 0 else max(-MAX_SPEED, velocity.x)
	velocity.y = min(MAX_SPEED, velocity.y) if velocity.y > 0 else max(-MAX_SPEED, velocity.y)
	
func _on_vision_range_body_entered(body):
	if body.name == "player":
		player = body

#func _on_vision_range_body_exited(body):
	#if body.name == "player":
		#player = null

func _on_hit_box_body_entered(body):
	if body.name == "player":
		attacking = true
		fish.play_attack_animation()
		body.push_back(position, push_power, damage)
		var direction = body.position.direction_to(position)
		velocity = position + direction * push_power * 10

func _on_fish_attack_finished():
	attacking = false
