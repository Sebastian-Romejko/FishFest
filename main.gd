extends Node2D

@onready var player = $player
@onready var camera = $camera
@onready var canvas_layer = $CanvasLayer
@onready var game_ui = $CanvasLayer/game_ui
@onready var menu = $CanvasLayer/menu
@onready var bottom_wall = $bottom_wall
@onready var parallax_background = $parallax_background
@onready var parallax_background2 = $parallax_background_2
@onready var music = $music

const GOAL_SCENE = preload("res://assets/goal.tscn")
const CUTSCENE_BORDERS_SCENE = preload("res://ui/cutscene_borders.tscn")
const LEVEL_END_SCENE = preload("res://ui/level_end_panel.tscn")
const GAME_OVER_SCENE = preload("res://ui/game_over_panel.tscn")
const PAUSE_SCENE = preload("res://ui/pause_panel.tscn")
const STARTING_ENERGY = 1000
const BOTTOM_WALL_OFFSET = 70

var energy = 1000
var level = 1
var level_config
var level_scene
var goal: int
var goal_scene
var game_over = false
var player_hit = false
var seaweed_collected = 0
var bottom_wall_starting_y
var camera_starting_offset_y
var cutscene_borders

func _ready():
	bottom_wall_starting_y = bottom_wall.position.y
	camera_starting_offset_y = camera.offset.y
	game_ui.set_energy(energy)
	start_level(level)
	
func _process(delta):
	var bottom_limit = min(player.position.y + 250, bottom_wall.position.y)
	bottom_wall.position.y = bottom_limit
	camera.limit_bottom = bottom_limit + 20
	
func start_level(level):
	level_config = Config.get_level(level)
	level_scene = load("res://assets/level_%s.tscn" % str(level)).instantiate()
	add_child(level_scene)
	level_scene.regen_energy.connect(_on_regen_energy)
	
	goal = level_config.goal * -1
	goal_scene = GOAL_SCENE.instantiate()
	add_child(goal_scene)
	goal_scene.position.y = goal
	goal_scene.reached.connect(_on_goal_reached)

func start_new_level():
	get_tree().paused = false
	player.visible = true
	parallax_background.visible = true
	parallax_background2.visible = true
	if cutscene_borders:
		cutscene_borders.queue_free()
		cutscene_borders = null
	if level_scene:
		level_scene.queue_free()
		level_scene = null
	if goal_scene:
		goal_scene.queue_free()
		goal_scene = null
	game_over = false
	player_hit = false
	seaweed_collected = 0
	bottom_wall.position.y = bottom_wall_starting_y
	energy = STARTING_ENERGY
	game_ui.visible = true
	game_ui.set_energy(energy)
	camera.offset.y = camera_starting_offset_y
	camera.limit_bottom = 1000000
	player.restart()
	await get_tree().create_timer(0.1).timeout
	start_level(level)

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
	start_new_level()
	
func _on_regen_energy(energy_gained):
	energy += energy_gained
	game_ui.set_energy(energy)
	seaweed_collected += 1

func _on_player_hit():
	player_hit = true
	
func _on_goal_reached():
	game_ui.visible = false
	level_scene.disapear_into_bubbles()
	cutscene_borders = CUTSCENE_BORDERS_SCENE.instantiate()
	canvas_layer.add_child(cutscene_borders)
	goal_scene.play_happy_animation(goal)
	player.play_happy_animation(goal)
	camera.offset.y = 0

func _on_player_happiness_ended():
	if cutscene_borders:
		cutscene_borders.queue_free()
		cutscene_borders = null
	var stars = {"1": true}
	stars["2"] = true if seaweed_collected == level_config.seaweed else false
	stars["3"] = true if not player_hit else false
	menu.set_stars(level, stars.values().filter(func(x): return x).size())
	level += 1
	menu.set_level_enable(level)
	var level_end_scene = LEVEL_END_SCENE.instantiate()
	canvas_layer.add_child(level_end_scene)
	level_end_scene.init(level, stars)
	level_end_scene.continue_pressed.connect(_on_continue_pressed)
	level_end_scene.menu_pressed.connect(_on_menu_clicked)
	
func _on_continue_pressed():
	start_new_level()

func _on_menu_level_choosen(_level):
	level = _level
	menu.visible = false
	game_ui.visible = true
	start_new_level()

func _on_game_ui_paused_pressed():
	var pause_panel = PAUSE_SCENE.instantiate()
	canvas_layer.add_child(pause_panel)
	pause_panel.resume_clicked.connect(_on_resume_clicked)
	pause_panel.retry_clicked.connect(_on_retry_clicked)
	pause_panel.menu_clicked.connect(_on_menu_clicked)
	get_tree().paused = true
	
func _on_resume_clicked():
	get_tree().paused = false
	
func _on_retry_clicked():
	start_new_level()

func _on_menu_clicked():
	player.visible = false
	parallax_background.visible = false
	parallax_background2.visible = false
	menu.visible = true
	game_ui.visible = false

func _on_music_finished():
	music.play()
