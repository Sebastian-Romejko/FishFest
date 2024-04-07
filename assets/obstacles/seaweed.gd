extends Sprite2D

signal regen_energy(energy: int)

@export var energy_value: int = 200

func _on_area_body_entered(body):
	if body.name == "player":
		regen_energy.emit(energy_value)
		queue_free()
