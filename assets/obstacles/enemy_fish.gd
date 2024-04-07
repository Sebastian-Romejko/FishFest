extends CharacterBody2D

@onready var fish = $sprite/sub_viewport/fish_enemy_1
@onready var viewport = $sprite/sub_viewport
@onready var vision_range_shape = $vision_range/collision_shape

@export var move_speed: float = 10
@export var max_speed: int = 25
@export var vision_range: int = 60
@export var max_distance: int = 85
@export var damage: int = 100
@export var push_power: int = 1

var player: Node2D
var attacking = false
var player_has_superpower = false
var temp_max_speed

func _ready():
	fish.play_idle_animation()
	vision_range_shape.shape.radius = vision_range

func _physics_process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	velocity /= 1.03
	
	if player:
		if position.distance_to(player.position) > max_distance:
			fish.play_idle_animation()
			player = null
			return
			
		look_at(player.position)
		var direction = position.direction_to(player.position)
		velocity += direction * move_speed / 10
		
		if player_has_superpower:
			limit_to_temp_max_speed()
		else:
			limit_to_max_speed()
		
		if !attacking:
			fish.play_swim_animation()
	move_and_slide()

func limit_to_max_speed():
	velocity.x = min(max_speed, velocity.x) if velocity.x > 0 else max(-max_speed, velocity.x)
	velocity.y = min(max_speed, velocity.y) if velocity.y > 0 else max(-max_speed, velocity.y)

func limit_to_temp_max_speed():
	velocity.x = min(temp_max_speed, velocity.x) if velocity.x > 0 else max(-temp_max_speed, velocity.x)
	velocity.y = min(temp_max_speed, velocity.y) if velocity.y > 0 else max(-temp_max_speed, velocity.y)
	
func _on_vision_range_body_entered(body):
	if body.name == "player":
		player = body

func _on_vision_range_body_exited(body):
	if body.name == "player":
		player = null

func _on_hit_box_body_entered(body):
	if body.name == "player":
		if body.superpower:
			player_has_superpower = true
			var direction = body.position.direction_to(position)
			velocity = position + direction * push_power
			temp_max_speed = max_speed * 8
		else:
			player_has_superpower = false
			attacking = true
			fish.play_attack_animation()
			body.push_back(position, push_power, damage)
			var direction = body.position.direction_to(position)
			velocity = position + direction * push_power * 4

func _on_fish_attack_finished():
	attacking = false
