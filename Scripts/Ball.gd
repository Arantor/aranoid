extends Area2D

enum BALL_MODE {UNDEF, CAUGHT, IN_MOTION}

var ball_mode = BALL_MODE.UNDEF
var ball_to_bat = 0
var player
var stored_velocity
var velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node('../Player')
	
	# Set up collisions with the sides.
	var wall_sides = get_node('../../WallSides')
	wall_sides.area_entered.connect(_on_wall_sides_area_entered)
	var wall_top = get_node('../../WallTop')
	wall_top.area_entered.connect(_on_wall_top_area_entered)
	
	# Set up the collisions with the bricks.
	var brick_container = get_node('../../BricksContainer')
	for brick in brick_container.get_children():
		brick.area_entered.connect(brick._on_ball_bounce)
		
	# Set up collision with the player.
	player.area_entered.connect(player._ball_bounce)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match ball_mode:
		BALL_MODE.UNDEF:
			pass
		BALL_MODE.CAUGHT:
			position.x = player.position.x + ball_to_bat
			velocity = Vector2(0, 0)
			pass
		BALL_MODE.IN_MOTION:
			position += velocity * delta
			pass

func _input(event):
	if event is InputEventMouseButton:
		if ball_mode == BALL_MODE.CAUGHT:
			velocity = stored_velocity
			ball_mode = BALL_MODE.IN_MOTION

func _on_wall_sides_area_entered(area):
	if ball_mode == BALL_MODE.IN_MOTION:
		velocity.x = -velocity.x

func _on_wall_top_area_entered(area):
	if ball_mode == BALL_MODE.IN_MOTION:
		velocity.y = -velocity.y

func bounce_off(brick):
	if ball_mode != BALL_MODE.IN_MOTION:
		return
	#
	#   1  |    2    |  3
	# -----+---------+-----
	#   4  |  BRICK  |  6
	# -----+---------+-----
	#   7  |    8    |  9
	#
	var left_of_brick = (position.x < brick.position.x)
	var above_brick = (position.y < brick.position.y)
	var brick_size = brick.get_node('CollisionShape2D').get_shape().size
	var right_of_brick = (position.x >= brick.position.x + brick_size.x)
	var below_brick = (position.y >= brick.position.y + brick_size.y)
	
	var travelling_left = velocity.x < 0
	var travelling_right = velocity.x > 0
	var travelling_up = velocity.y < 0
	var travelling_down = velocity.y > 0

	if above_brick:
		# 1 -> ball must be travelling right + down (bounce both)
		if travelling_right && travelling_down && left_of_brick:
			velocity *= 1
			return true
		# 2 -> ball must be travelling down (flip y)
		elif (!left_of_brick) && (!right_of_brick):
			velocity.y = -velocity.y
			return true
		# 3 -> ball must be travelling left + down (bounce both)
		elif travelling_left && travelling_down && right_of_brick:
			velocity *= 1
			return true
	elif (!above_brick) && (!below_brick):
		# 4 -> ball must be travelling right (flip x)
		if travelling_right && left_of_brick:
			velocity.x = -velocity.x
			return true
		# 6 -> ball must be travelling left (flip x)
		elif travelling_left && right_of_brick:
			velocity.x = -velocity.x
			return true
	elif below_brick:
		# 7 -> ball must be travelling up + right (flip both)
		if travelling_right && travelling_up && left_of_brick:
			velocity *= -1
			return true
		# 8 -> ball must be travelling up (flip y)
		elif (!left_of_brick) && (!right_of_brick):
			velocity.y = -velocity.y
			return true
		# 9 -> ball must be travelling up + left (flip both)
		elif travelling_left && travelling_up && right_of_brick:
			velocity *= -1
			return true

	return false
