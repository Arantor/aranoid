extends CharacterBody2D

@export var scores = 0
@export var hits = 1
@export var metallic = false
@export var destructible = true
var sound
var powerups

# Called when the node enters the scene tree for the first time.
func _ready():
	powerups = {
		'shield': preload("res://Entities/PowerupShield.tscn"),
		'superball': preload("res://Entities/PowerupSuperball.tscn"),
		'multiball': preload("res://Entities/PowerupMultiball.tscn")
	}
	if metallic:
		sound = get_node_or_null('../../Sounds/BrickMetalSound')
	else:
		sound = get_node_or_null('../../Sounds/BrickSound')

func hit(ball):
	# If the ball is a super ball, we're "handling the bounce" i.e. nothing.
	if ball.super_ball:
		Levels.CurrentScore += scores
		scores = 0
		print("Superball destroyed brick")
		queue_free()
		print("Checking for advance level")
		if not Levels.check_advance_level():
			print("Init powerup")
			spawn_powerup()
		return true

	sound.play()

	if destructible:
		hits -= 1
		if hits < 1:
			print("Applying score")
			Levels.CurrentScore += scores
			scores = 0
			print("Destroying brick")
			queue_free()
			print("Checking for advance level")
			if not Levels.check_advance_level():
				print("Init powerup")
				spawn_powerup()

	return false # We aren't handling the bounce

func spawn_powerup():
	# Don't spawn a powerup if one is already on screen in motion.
	var powerups_container = get_node('../../Powerups')
	if powerups_container.get_child_count() > 0:
		return

	var powerup = randi_range(1, 100)
	var newpowerup = ''

	if powerup > 25 and powerup <= 50:
		newpowerup = 'superball'
	if powerup > 50 and powerup <= 75:
		newpowerup = 'multiball'
	elif powerup > 75:
		newpowerup = 'shield'

	if newpowerup:
		var newpowerup_instance = powerups[newpowerup].instantiate()
		powerups_container.add_child(newpowerup_instance)
		newpowerup_instance.position = Vector2(position.x + 7, position.y + 17)
		newpowerup_instance.velocity = Vector2(0, 30)
