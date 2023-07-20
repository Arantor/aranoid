extends Node

var CurrentLevel = 0
var bricks = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	CurrentLevel = 1
	bricks = [
		false,
		preload("res://Entities/BrickRed.tscn"),
		preload("res://Entities/BrickLightBlue.tscn"),
		preload("res://Entities/BrickGreen.tscn"),
		preload("res://Entities/BrickBlue.tscn"),
		preload("res://Entities/BrickBrown.tscn"),
		false,
		false,
		false,
		false,
		preload("res://Entities/BrickSilver.tscn"),
		preload("res://Entities/BrickGold.tscn"),
	]

func populate_level(level):
	var level_to_build = get_level(CurrentLevel)
	for row in range(0, level_to_build.size()):
		for column in range(0, level_to_build[row].size()):
			if (level_to_build[row][column]):
				var brick = bricks[level_to_build[row][column]].instantiate()
				level.add_child(brick)
				brick.position.x = column * 7.5 + 13
				brick.position.y = row * 8 + 5


func get_level(level):
	match level:
		1:
			return [
				[11, 0,11, 0,11, 0,11, 0,11, 0,11, 0,11, 0,11, 0,11, 0,11, 0,11, 0,11, 0,11, 0,11, 0,11],
				[ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0 ,1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
				[ 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2],
				[ 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3],
				[ 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4],
				[ 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5],
				[10, 0,10, 0,10, 0,10, 0,10, 0,10, 0,10, 0,10, 0,10, 0,10, 0,10, 0,10, 0,10, 0,10, 0,10],
			]

	return []
