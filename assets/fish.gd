extends CharacterBody2D

@onready var viewport = $sprite/sub_viewport

@export var move_speed: int = 30

func _process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	
	velocity.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * move_speed
	velocity.y = (Input.get_action_strength("down") - Input.get_action_strength("up")) * move_speed
	
	look_at(global_position - velocity)
	
	move_and_slide()
