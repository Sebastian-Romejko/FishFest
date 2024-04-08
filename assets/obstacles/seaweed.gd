extends Sprite2D

signal regen_energy(energy: int)

@onready var viewport = $sub_viewport
@onready var seaweed = $sub_viewport/seaweed
@onready var particles = $particles

@export var energy_value: int = 200

func _process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE

func _on_area_body_entered(body):
	if body.name == "player":
		regen_energy.emit(energy_value)
		seaweed.visible = false
		particles.emitting = true
		await get_tree().create_timer(0.5).timeout
		queue_free()
