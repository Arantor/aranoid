extends CharacterBody2D

enum BALL_MODE {UNDEF, CAUGHT, IN_MOTION}

var ball_mode = BALL_MODE.UNDEF
var ball_to_bat = 0
var player
var stored_velocity
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node('../Player')

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

func _input(event):
	if event is InputEventMouseButton:
		if not player.is_active():
			return

		if ball_mode == BALL_MODE.CAUGHT:
			velocity = stored_velocity
			ball_mode = BALL_MODE.IN_MOTION
