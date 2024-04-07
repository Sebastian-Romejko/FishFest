extends CharacterBody2D

enum STATE {NORMAL, DEAD, HAPPY, NONE}

signal energy_used(energy)
signal hit()
signal happiness_ended()

@onready var bubbles = $bubbles
@onready var viewport = $sprite/sub_viewport
@onready var fish = $sprite/sub_viewport/fish
@onready var happy_timer = $happy_timer
@onready var superpower_timer = $superpower_timer

const MANA_USAGE_MODIFIER = 150
const MOVE_SPEED = 1
const MAX_SPEED = 50

var state = STATE.NORMAL
var superpower = false

var goal_position: Vector2
var target_position: Vector2

var was_hit = false
var happiness_already_ended = false

func _physics_process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	velocity /= 1.01
	
	match(state):
		STATE.NORMAL:
			var new_velocity = Vector2(0, 0)
			new_velocity.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * MOVE_SPEED
			new_velocity.y = (Input.get_action_strength("down") - Input.get_action_strength("up")) * MOVE_SPEED
			
			if new_velocity.x != 0 or new_velocity.y != 0:
				velocity += new_velocity
				
			look_at(global_position - velocity)
			
			limit_to_max_speed()
			move_and_slide()
			
			if (abs(velocity.x) > 5 or abs(velocity.y) > 5):
				energy_used.emit((abs(velocity.x) + abs(velocity.y)) / MANA_USAGE_MODIFIER)
				fish.play_swim_animation()
			else:
				fish.play_idle_animation()
		STATE.DEAD:
			fish.play_death_animation()
			state = STATE.NONE
		STATE.HAPPY:
			if position.distance_to(target_position) > 1:
				look_at(goal_position)
				var direction = position.direction_to(target_position)
				velocity = direction * MAX_SPEED / 1.5
				move_and_slide()
			else:
				if happy_timer.is_stopped() and !happiness_already_ended:
					fish.play_happy_animation()
					happy_timer.start()

func limit_to_max_speed():
	velocity.x = min(MAX_SPEED, velocity.x) if velocity.x > 0 else max(-MAX_SPEED, velocity.x)
	velocity.y = min(MAX_SPEED, velocity.y) if velocity.y > 0 else max(-MAX_SPEED, velocity.y)

func push_back(from: Vector2, power: int, damage: int):
	if !was_hit:
		was_hit = true
		hit.emit()
	var direction = from.direction_to(position)
	velocity = position + direction * power
	energy_used.emit(damage)
	bubbles.restart()
	
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
	
func restart():
	was_hit = false
	position = Vector2(0, 0)
	velocity = Vector2(0, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)
	tween.chain().tween_property(self, "scale", Vector2(1, 1), 1)
	tween.play()
	state = STATE.NORMAL
	
func gain_superpower():
	superpower = true
	superpower_timer.start()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(2, 2, 2), 1)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 1)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 1)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 1)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 1)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 1)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 0.4)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 0.4)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 0.4)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 0.4)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	tween.chain().tween_property(self, "modulate", Color(2, 2, 2), 0.4)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	tween.play()

func _on_happy_timer_timeout():
	happiness_ended.emit()
	happiness_already_ended = true

func _on_superpower_timer_timeout():
	superpower = false
