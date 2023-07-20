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
		'shield': preload("res://Entities/PowerupShield.tscn")
	}
	if metallic:
		sound = get_node('../../Sounds/BrickMetalSound')
	else:
		sound = get_node('../../Sounds/BrickSound')

func hit(ball):
	sound.play()
	
	if destructible:
		hits -= 1
		if hits < 1:
			ball.player.score += scores
			spawn_powerup()
			queue_free()

	return false # We aren't handling the bounce

func spawn_powerup():
	# Don't spawn a powerup if one is already on screen in motion.
	var powerups_container = get_node('../../Powerups')
	if powerups_container.get_child_count() > 0:
		return

	var powerup = randi_range(1, 100)
	if powerup > 50:
		var shield = powerups['shield'].instantiate()
		powerups_container.add_child(shield)
		shield.position = Vector2(position.x + 7, position.y + 17)
		shield.velocity = Vector2(0, 30)
