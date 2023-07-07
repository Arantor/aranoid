extends CharacterBody2D

@export var scores = 0
@export var hits = 1
@export var metallic = false
@export var destructible = true
var sound

# Called when the node enters the scene tree for the first time.
func _ready():
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
			queue_free()

	return false # We aren't handling the bounce
