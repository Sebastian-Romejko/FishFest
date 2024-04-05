extends Node2D

signal regen_energy(energy: int)

func _on_seaweed_regen_energy(energy):
	regen_energy.emit(energy)
