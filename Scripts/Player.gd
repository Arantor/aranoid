extends Area2D

var ball = preload("res://Entities/Ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = 124
	position.y = 163
	var levels_container = get_node('../BricksContainer')
	Levels.populate_level(levels_container)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		position.x += event.relative.x
	position.x = clamp(position.x, 33, 218)
