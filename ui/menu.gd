extends Control

signal level_choosen(level)

@onready var level1 = $panel_container/margin_container/v_box_container/box_container/level
@onready var level2 = $panel_container/margin_container/v_box_container/box_container/level2
@onready var level3 = $panel_container/margin_container/v_box_container/box_container/level3
@onready var level4 = $panel_container/margin_container/v_box_container/box_container/level4
@onready var level5 = $panel_container/margin_container/v_box_container/box_container/level5

var levels: Dictionary

func _ready():
	levels = {
		1: level1,	
		2: level2,
		3: level3,
		4: level4,
		5: level5
	}
	level4.set_enable()

func set_stars(level, stars):
	levels[level].set_stars(stars)

func set_level_enable(level):
	levels[level].set_enable()

func _on_level_choosen(level):
	level_choosen.emit(level)
