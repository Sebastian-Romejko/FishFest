extends Node

const CONFIG_PATH = "res://config.json"

var config: Dictionary

func _init():
	var file = FileAccess.open(CONFIG_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	config = JSON.parse_string(content)
	
func get_level(level: int):
	return config.levels[str(level)]
