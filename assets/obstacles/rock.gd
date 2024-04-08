extends Sprite2D

@onready var viewport = $sub_viewport
@onready var camera = $sub_viewport/camera

var camera_positions = [
	Vector3(0, 5, 1),
	Vector3(1, 5, 0),
	Vector3(0, 5, -1),
	Vector3(-1, 5, 0)
]

var camera_rotations = [
	Vector3(deg_to_rad(-79), deg_to_rad(0), deg_to_rad(0)),
	Vector3(deg_to_rad(-79), deg_to_rad(90), deg_to_rad(0)),
	Vector3(deg_to_rad(-79), deg_to_rad(180), deg_to_rad(0)),
	Vector3(deg_to_rad(-79), deg_to_rad(270), deg_to_rad(0))
]

func _ready():
	rotation = deg_to_rad(randi_range(0, 360))
	await get_tree().create_timer(0.1).timeout
	var random_number = randi_range(0, 3)
	camera.position = camera_positions[random_number]
	camera.rotation = camera_rotations[random_number]
	viewport.render_target_update_mode = viewport.UPDATE_ONCE
