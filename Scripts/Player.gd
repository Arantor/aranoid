extends CharacterBody2D

var ball = preload("res://Entities/Ball.tscn")
var ball_group
var collide_sound
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = 124
	position.y = 155
	var levels_container = get_node('../../BricksContainer')
	Levels.populate_level(levels_container)
	
	collide_sound = get_node('../../Sounds/PlayerSound')
	
	var current_ball = ball.instantiate()
	ball_group = get_node('../Balls')
	ball_group.add_sibling.call_deferred(current_ball)
	current_ball.position = Vector2(124, 150)
	current_ball.stored_velocity = Vector2(60, -60)
	current_ball.ball_to_bat = 0
	current_ball.ball_mode = current_ball.BALL_MODE.CAUGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		position.x += event.relative.x
	position.x = clamp(position.x, 33, 216)

func _ball_bounce(current_ball):
	if "velocity" not in current_ball:
		return

	current_ball.velocity.y = -current_ball.velocity.y
	collide_sound.play()

func hit(ball):
	collide_sound.play()
	
	return false # We aren't handling the bounce (yet)
