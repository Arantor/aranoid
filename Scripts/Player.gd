extends CharacterBody2D

var optionsmenu
var the_ball = preload("res://Entities/Ball.tscn")
var ball_group
var collide_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	collide_sound = get_node('../../Sounds/PlayerSound')
	optionsmenu = preload("res://Entities/OptionsMenu.tscn")
	reset_player()

func reset_player(reset_position = true):
	if Levels.GameOver:
		return

	print("Player init")
	if reset_position:
		position.x = 124
		position.y = 155

	print("Level population")
	var levels_container = get_node('../../BricksContainer')
	if Levels.get_remaining_brick_count() == 0:
		Levels.populate_level(levels_container)

	print("Ball anim")
	$Launch.visible = true
	$Launch.play()

func _on_launch_animation_finished():
	print("Instantiating ball")
	$Launch.visible = false
	var current_ball = the_ball.instantiate()
	ball_group = get_node('../Balls')
	ball_group.add_child.call_deferred(current_ball)
	current_ball.position = Vector2(position.x, position.y - 5)
	current_ball.stored_velocity = Vector2(60, -60)
	current_ball.ball_to_bat = 0
	current_ball.ball_mode = current_ball.BALL_MODE.CAUGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if Levels.GameOver:
		return

	if event is InputEventMouseMotion:
		position.x += event.relative.x
	position.x = clamp(position.x, 33, 216)

	if Input.is_key_pressed(KEY_ESCAPE):
		var options = optionsmenu.instantiate()
		get_parent().add_child(options)
		options.position = Vector2(34, 2)

func _ball_bounce(current_ball):
	if "velocity" not in current_ball:
		return

	current_ball.velocity.y = -current_ball.velocity.y
	collide_sound.play()

func hit(_ball):
	collide_sound.play()
	
	return false # We aren't handling the bounce (yet)
