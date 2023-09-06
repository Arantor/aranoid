extends CharacterBody2D

var optionsmenu
var the_ball = preload("res://Entities/Ball.tscn")
var ball_group
var collide_sound
var width_from_center

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

	print("Getting size of bat collider")
	var left_most = Vector2(0, 0)
	var right_most = Vector2(0, 0)
	for point in get_node('CollisionPolygon2D').get_polygon():
		if point.x < left_most.x:
			left_most.x = point.x
		if point.x > right_most.x:
			right_most.x = point.x
	width_from_center = max(right_most.x, -left_most.x)
	print(width_from_center)

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

func _physics_process(delta):
	move_and_slide()
	velocity.x = 0

func _input(event):
	if Levels.GameOver:
		return

	if event is InputEventMouseMotion:
		velocity.x = event.relative.x * (30 + 10 * Config.get_value('mouse_sensitivity'))

	if Input.is_key_pressed(KEY_ESCAPE) or Input.is_key_pressed(KEY_SPACE):
		var options = optionsmenu.instantiate()
		get_parent().add_child(options)
		options.position = Vector2(34, 2)

func hit(ball, collision):
	var collision_point = collision.get_position() - position

	# If you're hitting the underside, it's just going to ping off, slightly faster.
	if collision_point.y > 7:
		ball.velocity = ball.velocity.bounce(collision.get_normal())
		ball.add_collision_exception_with(self)
		ball.velocity.y = abs(ball.velocity.y) # Make sure y is +ve so it goes 'down'
		return true # We handled the bounce already.

	# If you're hitting the top, then, work out the new angle based on where you hit.
	var ball_speed = ball.get_velocity_from_vector(ball.velocity)
	var new_angle = sign(collision_point.x) * ((abs(collision_point.x) / width_from_center) * 55)
	ball.velocity = ball.get_new_vector_from_velocity_angle(ball_speed, new_angle - 90)
	
	collide_sound.play()
	
	return true # We are handling the bounce.
