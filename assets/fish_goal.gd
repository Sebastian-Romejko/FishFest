extends CharacterBody2D

@onready var viewport = $sprite/sub_viewport
@onready var fish = $sprite/sub_viewport/fish_goal

var move_speed: int = 70

var happy = false
var goal_position: Vector2
var target_position: Vector2

func _physics_process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	if happy:
		if global_position.distance_to(target_position) > 1:
			look_at(goal_position)
			var direction = global_position.direction_to(target_position)
			velocity = direction * move_speed
			move_and_slide()
		else:
			fish.play_happy_animation()
	
func play_happy_animation(goal_height: int):
	goal_position = Vector2(0 - 50, goal_height)
	target_position = Vector2(0 - 30, goal_height)
	happy = true
