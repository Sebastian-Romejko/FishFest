extends Node2D

@onready var viewport = $sprite/sub_viewport

func _process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
