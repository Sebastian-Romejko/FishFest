extends Node2D

@onready var player = $player
@onready var camera = $camera
@onready var canvas_layer = $CanvasLayer
@onready var game_ui = $CanvasLayer/game_ui
@onready var bottom_wall = $bottom_wall

const GOAL_SCENE = preload("res://assets/goal.tscn")
const CUTSCENE_BORDERS_SCENE = preload("res://ui/cutscene_borders.tscn")
const LEVEL_END_SCENE = preload("res://ui/level_end_panel.tscn")
const GAME_OVER_SCENE = preload("res://ui/game_over_panel.tscn")
const STARTING_ENERGY = 1000
const BOTTOM_WALL_OFFSET = 70

var energy = 1000
var level = 1
var level_scene
var goal: int
var goal_scene
var game_over = false
var bottom_wall_starting_y

func _ready():
	bottom_wall_starting_y = bottom_wall.position.y
	game_ui.set_energy(energy)
	start_level(level)
	
func _process(delta):
	var bottom_limit = min(player.position.y + 120, bottom_wall.position.y)
	bottom_wall.position.y = bottom_limit
	camera.limit_bottom = bottom_limit + 20
	
func start_level(level):
	level_scene = load("res://assets/level_%s.tscn" % str(level)).instantiate()
	add_child(level_scene)
	level_scene.regen_energy.connect(_on_regen_energy)
	
	goal = Config.get_level(level).goal * -1
	goal_scene = GOAL_SCENE.instantiate()
	add_child(goal_scene)
	goal_scene.position.y = goal
	goal_scene.reached.connect(_on_goal_reached)

func _on_fish_energy_used(energy_used):
	energy -= energy_used
	game_ui.set_energy(energy)
	if energy <= 0:
		player.play_death_animation()
		if !game_over:
			var game_over_scene = GAME_OVER_SCENE.instantiate()
			canvas_layer.add_child(game_over_scene)
			game_over_scene.restart_clicked.connect(_on_restart_clicked)
			game_over = true
	
func _on_restart_clicked():
	game_over = false
	bottom_wall.position.y = bottom_wall_starting_y
	camera.limit_bottom = 1000000
	energy = STARTING_ENERGY
	player.restart()
	level_scene.queue_free()
	goal_scene.queue_free()
	start_level(level)
	
func _on_regen_energy(energy_gained):
	energy += energy_gained
	game_ui.set_energy(energy)
	
func _on_goal_reached():
	level_scene.disapear_into_bubbles()
	canvas_layer.add_child(CUTSCENE_BORDERS_SCENE.instantiate())
	goal_scene.play_happy_animation(goal)
	player.play_happy_animation(goal)
	camera.offset.y = 0

func _on_player_happiness_ended():
	var level_end_scene = LEVEL_END_SCENE.instantiate()
	canvas_layer.add_child(level_end_scene)
	level_end_scene.init(level, 100)
	level_end_scene.continue_pressed.connect(_on_continue_pressed)
	
func _on_continue_pressed():
	level += 1
	energy = STARTING_ENERGY
	game_ui.set_energy(energy)
	camera.limit_bottom = 1000000
