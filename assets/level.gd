extends Node2D

signal regen_energy(energy: int)

const BUBBLES_SCENE = preload("res://assets/bubbles.tscn")

func _ready():
	for child in get_children():
		if child.name == "seaweed":
			for seaweed in child.get_children():
				seaweed.regen_energy.connect(_on_seaweed_regen_energy)
	
func disapear_into_bubbles():
	var child_positions = []
	for child in get_children():
		for inner_child in child.get_children():
			child_positions.append(inner_child.global_position)
			inner_child.queue_free()
		
	for child_position in child_positions:
		var bubbles = BUBBLES_SCENE.instantiate()
		add_child(bubbles)
		bubbles.position = child_position
		bubbles.restart()

func _on_seaweed_regen_energy(energy):
	regen_energy.emit(energy)
