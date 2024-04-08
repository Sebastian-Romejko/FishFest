extends Node2D

const BUBBLE_SCENE = preload("res://assets/random_bubble.tscn")

@export var amount: int = 10
@export var width: float = 0
@export var height: float = 0

func _ready():
	for bubble in range(amount):
		var bubble_scene = BUBBLE_SCENE.instantiate()
		add_child(bubble_scene)
		bubble_scene.position = Vector2(randf_range(-width/2, width/2), randf_range(0, -height))
		print(bubble_scene.position)
