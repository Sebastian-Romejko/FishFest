extends Control

signal continue_pressed()

@onready var level_label = $v_box_container/level_label
@onready var star_finished = $v_box_container/margin_container/v_box_container_stars/h_box_container_star/star
@onready var star_seaweed = $v_box_container/margin_container/v_box_container_stars/h_box_container_star2/star
@onready var star_no_damage = $v_box_container/margin_container/v_box_container_stars/h_box_container_star3/star

func init(level: int, stars: Dictionary):
	print(stars)
	level_label.text = "LEVEL " + str(level)
	if stars["1"]:
		star_finished.set_enable()
	if stars["2"]:
		star_seaweed.set_enable()
	if stars["3"]:
		star_no_damage.set_enable()

func _on_continue_button_pressed():
	continue_pressed.emit()
	queue_free()
