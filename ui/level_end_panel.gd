extends Control

signal continue_pressed()
signal menu_pressed()

@onready var level_label = $v_box_container/level_label
@onready var star_finished = $v_box_container/margin_container/v_box_container_stars/h_box_container_star/star
@onready var star_seaweed = $v_box_container/margin_container/v_box_container_stars/h_box_container_star2/star
@onready var star_no_damage = $v_box_container/margin_container/v_box_container_stars/h_box_container_star3/star
@onready var button_sound = $button_sound

func init(level: int, stars: Dictionary):
	level_label.text = "LEVEL " + str(level)
	if stars["1"]:
		await get_tree().create_timer(0.7).timeout
		star_finished.set_enable()
	if stars["2"]:
		await get_tree().create_timer(0.7).timeout
		star_seaweed.set_enable()
	if stars["3"]:
		await get_tree().create_timer(0.7).timeout
		star_no_damage.set_enable()

func _on_continue_button_pressed():
	button_sound.play()
	continue_pressed.emit()
	queue_free()

func _on_menu_button_pressed():
	button_sound.play()
	menu_pressed.emit()
	queue_free()
