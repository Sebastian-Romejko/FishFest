extends Control

signal level_choosen(level)

@onready var button = $v_box_container/button
@onready var star1 = $v_box_container/h_box_container/star2
@onready var star2 = $v_box_container/h_box_container/star3
@onready var star3 = $v_box_container/h_box_container/star4

@export var level: int = 1

func _ready():
	button.text = str(level)

func set_enable():
	button.disabled = false

func set_stars(stars):
	if stars >= 1:
		star1.set_enable()
	if stars >= 2:
		star2.set_enable()
	if stars >= 3:
		star3.set_enable()

func _on_button_pressed():
	level_choosen.emit(level)
