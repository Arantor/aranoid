extends Area2D

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ball_bounce(ball):
	if ball.bounce_off(self):
		sound.play()
		
		if destructible:
			hits -= 1
			if hits < 1:
				ball.player.score += scores
				print("Added: " + str(scores) + ", total: " + str(ball.player.score))
				queue_free()
