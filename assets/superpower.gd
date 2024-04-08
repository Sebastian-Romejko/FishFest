extends Sprite2D

@onready var viewport = $sub_viewport
@onready var superpower = $sub_viewport/superpower
@onready var sound = $sound

const ROTATION = 0.01

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.9, 0.9, 0.9, 1), 1)
	tween.finished.connect(_on_tween_1_completed)
	tween.play()

func _on_tween_1_completed():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.3, 1.3, 1.3, 1), 1)
	tween.finished.connect(_on_tween_2_completed)
	tween.play()

func _on_tween_2_completed():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.9, 0.9, 0.9, 1), 1)
	tween.finished.connect(_on_tween_1_completed)
	tween.play()

func _process(delta):
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
	superpower.rotation.y += ROTATION

func _on_area_2d_body_entered(body):
	if body.name == "player":
		sound.play()
		body.gain_superpower()
		queue_free()
