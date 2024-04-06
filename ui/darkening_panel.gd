extends Panel

@export var starting_color = Color(1, 1, 1, 0.5)
@export var time_to_darken = 10

func _ready():
	modulate = starting_color
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), time_to_darken)
