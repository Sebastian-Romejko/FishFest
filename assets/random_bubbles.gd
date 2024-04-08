extends Node2D

const BUBBLE_SCENE = preload("res://assets/random_bubble.tscn")

@export var amount: int = 10
@export var width: float = 0
@export var height: float = 0

const MIN_DISTANCE = 80

func _ready():
	for bubble in range(amount):
		var bubble_scene = BUBBLE_SCENE.instantiate()
		add_child(bubble_scene)
		for i in range(100):
			var random_position = Vector2(randf_range(-width/2, width/2), randf_range(0, -height))
			if not get_children().any(func(x): return x.position.distance_to(random_position) < MIN_DISTANCE):
				bubble_scene.position = random_position
				break
		
