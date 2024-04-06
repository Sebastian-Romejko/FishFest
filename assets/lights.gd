extends Node2D

const LIGHT_SCENE = preload("res://assets/light.tscn")

@export var amount: int = 10
@export var width: float = 0
@export var height: float = 0

func _ready():
	for light in range(amount):
		var light_scene = LIGHT_SCENE.instantiate()
		add_child(light_scene)
		light_scene.position = Vector2(randf_range(-width/2, width/2), randf_range(0, height))
