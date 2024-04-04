extends CharacterBody2D

signal energy_used(energy)

@onready var viewport = $sprite/sub_viewport

@export var move_speed: int = 70

func _physics_process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	velocity.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * move_speed
	velocity.y = (Input.get_action_strength("down") - Input.get_action_strength("up")) * move_speed
	
	look_at(global_position - velocity)
	
	move_and_slide()
	
	if velocity.y != 0 or velocity.x != 0:
		energy_used.emit(0.5)
