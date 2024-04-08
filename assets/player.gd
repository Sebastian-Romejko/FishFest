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
@onready var pushed_back_timer = $pushed_back_timer
@onready var swim_sound = $swim_sound
@onready var enemy_hit_sound = $enemy_hit_sound

const MANA_USAGE_MODIFIER = 150
const MOVE_SPEED = 1
const MAX_SPEED = 50
const TEMP_MAX_SPEED = 100

var state = STATE.NORMAL
var superpower = false

var goal_position: Vector2
var target_position: Vector2

var was_hit = false
var pushed_back = false

var swim_sound_playing = false

func _physics_process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	velocity /= 1.01
	
	match(state):
		STATE.NORMAL:
			var new_velocity = Vector2(0, 0)
			new_velocity.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * MOVE_SPEED
			new_velocity.y = (Input.get_action_strength("down") - Input.get_action_strength("up")) * MOVE_SPEED
			
			if new_velocity.x != 0 or new_velocity.y != 0:
				velocity += new_velocity.normalized()
				
			look_at(global_position - velocity)
			
			if pushed_back:
				limit_to_temp_max_speed()
			else:
				limit_to_max_speed()
			move_and_slide()
			
			if (abs(velocity.x) > 5 or abs(velocity.y) > 5):
				energy_used.emit((abs(velocity.x) + abs(velocity.y)) / MANA_USAGE_MODIFIER)
				fish.play_swim_animation()
				if not swim_sound_playing:
					swim_sound.play()
					swim_sound_playing = true
			else:
				if swim_sound_playing:
					swim_sound.stop()
					swim_sound_playing = false
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
				if happy_timer.is_stopped():
					state = STATE.NONE
					fish.play_happy_animation()
					happy_timer.start()

func limit_to_max_speed():
	velocity.x = min(MAX_SPEED, velocity.x) if velocity.x > 0 else max(-MAX_SPEED, velocity.x)
	velocity.y = min(MAX_SPEED, velocity.y) if velocity.y > 0 else max(-MAX_SPEED, velocity.y)

func limit_to_temp_max_speed():
	velocity.x = min(TEMP_MAX_SPEED, velocity.x) if velocity.x > 0 else max(-TEMP_MAX_SPEED, velocity.x)
	velocity.y = min(TEMP_MAX_SPEED, velocity.y) if velocity.y > 0 else max(-TEMP_MAX_SPEED, velocity.y)

func push_back(from: Vector2, power: int, damage: int):
	enemy_hit_sound.play()
	pushed_back = true
	pushed_back_timer.start()
	if !was_hit:
		was_hit = true
		hit.emit()
	var direction = (position - from)#.normalized()
	velocity = Vector2(direction.x * power, direction.y * power) / 2
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
	
func _on_superpower_timer_timeout():
	superpower = false

func _on_pushed_back_timer_timeout():
	pushed_back = false

func _on_swim_sound_finished():
	swim_sound_playing = false
