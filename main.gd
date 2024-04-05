extends Node2D

@onready var player = $player
@onready var camera = $camera
@onready var game_ui = $CanvasLayer/game_ui
@onready var bottom_wall = $bottom_wall

const GOAL_SCENE = preload("res://ui/assets/goal.tscn")
const BOTTOM_WALL_OFFSET = 70

var energy = 1000
var level = 1
var goal: int

func _ready():
	game_ui.set_energy(energy)
	start_level(level)
	
func _process(delta):
	bottom_wall.position.y = min(player.position.y + 70, bottom_wall.position.y)

func _on_fish_energy_used(energy_used):
	energy -= energy_used
	game_ui.set_energy(energy)
	if energy <= 0:
		player.play_death_animation()
	
func _on_regen_energy(energy_gained):
	energy += energy_gained
	game_ui.set_energy(energy)
	
func start_level(level):
	var level_scene = load("res://ui/assets/level_%s.tscn" % str(level)).instantiate()
	add_child(level_scene)
	level_scene.regen_energy.connect(_on_regen_energy)
	
	goal = Config.get_level(level).goal * -1
	var goal_scene = GOAL_SCENE.instantiate()
	add_child(goal_scene)
	goal_scene.position.y = goal
