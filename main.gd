extends Node2D

@onready var camera = $camera
@onready var game_ui = $CanvasLayer/game_ui

var energy = 1000

func _ready():
	game_ui.set_energy(energy)

func _on_fish_energy_used(energy_used):
	energy -= energy_used
	game_ui.set_energy(energy)
