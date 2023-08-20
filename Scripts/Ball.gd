extends CharacterBody2D

enum BALL_MODE {UNDEF, CAUGHT, IN_MOTION}

var ball_mode = BALL_MODE.UNDEF
var ball_to_bat = 0
var player
var stored_velocity
var timer = 0
var super_ball = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node('../../Player')

func _physics_process(delta):
	match ball_mode:
		BALL_MODE.UNDEF:
			pass
		BALL_MODE.CAUGHT:
			position.x = player.position.x + ball_to_bat
			velocity = Vector2(0, 0)
			pass
		BALL_MODE.IN_MOTION:
			var collision = move_and_collide(velocity * delta)
			if collision:
				var handled_bounce = false

				var parent_object = collision.get_collider()
				if parent_object.has_method("hit"):
					handled_bounce = parent_object.hit(self)
					
				if !handled_bounce:
					velocity = velocity.bounce(collision.get_normal())

			timer += delta
			if timer > 15:
				var new_velocity = velocity * 1.25
				if get_velocity_from_vector(new_velocity) < 320:
					velocity = new_velocity
				timer = 0

func get_velocity_from_vector(vel):
	return sqrt((vel.x * vel.x) + (vel.y * vel.y))

func get_angle_from_vector(vel):
	var angle = rad_to_deg(atan(vel.y / vel.x))
	if vel.x < 0:
		angle += 180
	elif vel.y < 0:
		angle += 360
	return angle

func get_new_vector_from_velocity_angle(vel, angle):
	var rad_angle = deg_to_rad(angle)
	return Vector2(cos(rad_angle) * vel, sin(rad_angle) * vel)

func _input(event):
	if event is InputEventMouseButton:
		if not player.is_active():
			return

		if ball_mode == BALL_MODE.CAUGHT:
			velocity = stored_velocity
			ball_mode = BALL_MODE.IN_MOTION

func clone():
	var ball_clone = duplicate()
	ball_clone.stored_velocity = stored_velocity
	ball_clone.velocity = velocity
	ball_clone.ball_mode = ball_mode
	ball_clone.timer = timer
	ball_clone.super_ball = super_ball
	return ball_clone

func multi_split(count):
	if count == 3:
		var deviance = 15
		var ball1 = clone()
		var ball2 = clone()
		var current_vel = get_velocity_from_vector(velocity)
		var current_angle = get_angle_from_vector(velocity)
		ball1.velocity = get_new_vector_from_velocity_angle(current_vel, current_angle - deviance)
		ball2.velocity = get_new_vector_from_velocity_angle(current_vel, current_angle + deviance)
		get_parent().add_child(ball1)
		get_parent().add_child(ball2)
	else:
		print("Multi split called with unsupported number: " + str(count))

func set_linear_velocity(vel):
	var current_angle = get_angle_from_vector(velocity)
	velocity = get_new_vector_from_velocity_angle(vel, current_angle)

func set_superball():
	super_ball = true
	$Ball.visible = false
	$"Ball-super".visible = true

func set_nonsuperball():
	super_ball = false
	$Ball.visible = true
	$"Ball-super".visible = false
