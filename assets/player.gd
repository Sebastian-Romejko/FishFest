extends CharacterBody2D

signal energy_used(energy)

@onready var viewport = $sprite/sub_viewport

@export var move_speed: int = 70

var pushing_back = false

func _physics_process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	if !pushing_back:
		velocity.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * move_speed
		velocity.y = (Input.get_action_strength("down") - Input.get_action_strength("up")) * move_speed
		
		look_at(global_position - velocity)
	
		move_and_slide()
	
	if velocity.y != 0 or velocity.x != 0:
		energy_used.emit(0.5)
	
func push_back(from: Vector2, power: int):
	pushing_back = true
	var tween = get_tree().create_tween()
	var direction = from.direction_to(position)
	tween.tween_property(self, "position", position + direction * power, 1)
	tween.play()
	tween.tween_callback(push_back_finished)
	
func push_back_finished():
	pushing_back = false
