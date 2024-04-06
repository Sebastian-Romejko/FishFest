extends CharacterBody2D

enum STATE {NORMAL, DEAD, HAPPY}

signal energy_used(energy)

@onready var bubbles = $bubbles
@onready var viewport = $sprite/sub_viewport
@onready var fish = $sprite/sub_viewport/fish

@export var move_speed: int = 70

var pushing_back = false
var state = STATE.NORMAL

var goal_position: Vector2
var target_position: Vector2

func _physics_process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	match(state):
		STATE.NORMAL:
			velocity.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * move_speed
			velocity.y = (Input.get_action_strength("down") - Input.get_action_strength("up")) * move_speed
			
			if pushing_back:
				velocity /= 5
			
			look_at(global_position - velocity)

			move_and_slide()
			
			if velocity.y != 0 or velocity.x != 0:
				energy_used.emit(0.5)
				fish.play_swim_animation()
			else:
				fish.play_idle_animation()
		STATE.DEAD:
			pass
		STATE.HAPPY:
			look_at(goal_position)
			if position.distance_to(target_position) > 0.5:
				var direction = position.direction_to(target_position)
				velocity = direction * move_speed
				move_and_slide()
			else:
				fish.play_happy_animation()
			
	
func push_back(from: Vector2, power: int):
	pushing_back = true
	var tween = get_tree().create_tween()
	var direction = from.direction_to(position)
	tween.tween_property(self, "position", position + direction * power, 1)
	tween.play()
	tween.tween_callback(push_back_finished)
	energy_used.emit(power)
	bubbles.restart()
	
func push_back_finished():
	pushing_back = false
	
func play_death_animation():
	state = STATE.DEAD
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	tween.chain().tween_property(self, "scale", Vector2(0.8, 0.8), 1)
	tween.play()
	
func play_happy_animation(goal_height: int):
	goal_position = Vector2(0 + 50, goal_height)
	target_position = Vector2(0 + 30, goal_height)
	state = STATE.HAPPY
	
