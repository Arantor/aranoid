extends Area2D

var scores
var hits
var sound

# Called when the node enters the scene tree for the first time.
func _ready():
	scores = 5
	hits = 1
	sound = get_node('../../Sounds/BrickSound')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ball_bounce(ball):
	if ball.bounce_off(self):
		sound.play()
		hits -= 1
		if hits < 1:
			ball.player.score += scores
			queue_free()
