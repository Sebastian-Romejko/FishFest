extends CharacterBody2D

@onready var fish = $sprite/sub_viewport/fish_enemy
@onready var viewport = $sprite/sub_viewport
@onready var vision_range_shape = $vision_range/collision_shape
@onready var swim_sound = $swim_sound
@onready var start_swimming_sound = $start_swimming_sound

@export var move_speed: float = 10
@export var max_speed: int = 25
@export var vision_range: int = 60
@export var max_distance: int = 90
@export var damage: int = 100
@export var push_power: int = 1

var player: Node2D
var player_in_range = false
var attacking = false
var player_has_superpower = false
var temp_max_speed
var swim_sound_playing = false

func _ready():
	fish.play_idle_animation()
	vision_range_shape.shape.radius = vision_range

func _physics_process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	velocity /= 1.03
	
	if player_in_range or (player and position.distance_to(player.position) < vision_range):
		if position.distance_to(player.position) > max_distance:
			fish.play_idle_animation()
			player_in_range = false
			return
			
		look_at(player.position)
			
		if !attacking:
			fish.play_swim_animation()
			var direction = position.direction_to(player.position)
			velocity += direction * move_speed / 10
			if not swim_sound_playing:
				swim_sound.play()
				swim_sound_playing = true
		
		if player_has_superpower:
			limit_to_temp_max_speed()
		else:
			limit_to_max_speed()
	move_and_slide()

func limit_to_max_speed():
	velocity.x = min(max_speed, velocity.x) if velocity.x > 0 else max(-max_speed, velocity.x)
	velocity.y = min(max_speed, velocity.y) if velocity.y > 0 else max(-max_speed, velocity.y)

func limit_to_temp_max_speed():
	velocity.x = min(temp_max_speed, velocity.x) if velocity.x > 0 else max(-temp_max_speed, velocity.x)
	velocity.y = min(temp_max_speed, velocity.y) if velocity.y > 0 else max(-temp_max_speed, velocity.y)
	
func _on_vision_range_body_entered(body):
	if body.name == "player":
		start_swimming_sound.play()
		player = body
		player_in_range = true

func _on_vision_range_body_exited(body):
	if body.name == "player":
		player_in_range = false

func _on_hit_box_body_entered(body):
	if body.name == "player":
		if body.superpower:
			player_has_superpower = true
			var direction = body.position.direction_to(position)
			velocity = position + direction * push_power
			temp_max_speed = max_speed * 6
		else:
			player_has_superpower = false
			attacking = true
			fish.play_attack_animation()
			body.push_back(position, push_power, damage)
			var direction = position - body.position
			velocity = direction * push_power * 25
			$pushed_back_timer.start()

func _on_pushed_back_timer_timeout():
	attacking = false
	
func _on_swim_sound_finished():
	swim_sound_playing = false
