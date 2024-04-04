extends Node2D

@onready var camera = $camera
@onready var game_ui = $CanvasLayer/game_ui

const GOAL_SCENE = preload("res://ui/assets/goal.tscn")

var energy = 1000
var level = 1
var goal: int

func _ready():
	game_ui.set_energy(energy)
	start_level(level)

func _on_fish_energy_used(energy_used):
	energy -= energy_used
	game_ui.set_energy(energy)
	
func start_level(level):
	var level_scene = load("res://ui/assets/level_%s.tscn" % str(level)).instantiate()
	add_child(level_scene)
	
	goal = Config.get_level(level).goal * -1
	var goal_scene = GOAL_SCENE.instantiate()
	add_child(goal_scene)
	goal_scene.position.y = goal
