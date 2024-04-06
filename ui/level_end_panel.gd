extends Control

signal continue_pressed()

@onready var level_label = $v_box_container/level_label
@onready var score_label = $v_box_container/score_label

func init(level: int, score: int):
	level_label.text = "LEVEL " + str(level)
	score_label.text = "SCORE: " + str(score)

func _on_continue_button_pressed():
	continue_pressed.emit()
	queue_free()