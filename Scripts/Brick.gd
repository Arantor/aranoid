extends CharacterBody2D

@export var scores = 0
@export var hits = 1
@export var metallic = false
@export var destructible = true
var sound
var powerups

# Called when the node enters the scene tree for the first time.
func _ready():
	if metallic:
		sound = get_node_or_null('../../Sounds/BrickMetalSound')
	else:
		sound = get_node_or_null('../../Sounds/BrickSound')

func hit(ball, _collision):
	# If the ball is not technically in motion, it can't collide.
	if ball.is_queued_for_deletion():
		return false

	# If it's not destructible, play the sound and let it be bounce managed.
	if not destructible:
		sound.play()
		return false

	# If the ball is a super ball, we're "handling the bounce" i.e. nothing.
	if ball.super_ball:
		Levels.score_points(scores)
		scores = 0
		print("Superball destroyed brick")
		queue_free()
		print("Checking for advance level")
		if not Levels.check_advance_level():
			PowerupManager.check_spawn(position)
		return true

	sound.play()

	if destructible:
		hits -= 1
		if hits < 1:
			Levels.score_points(scores)
			scores = 0
			print("Destroying brick")
			queue_free()
			print("Checking for advance level")
			if not Levels.check_advance_level():
				PowerupManager.check_spawn(position)

	return false # We aren't handling the bounce
