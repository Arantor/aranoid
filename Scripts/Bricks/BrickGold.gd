extends Area2D

var sound

# Called when the node enters the scene tree for the first time.
func _ready():
	sound = get_node('../../Sounds/BrickMetalSound')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ball_bounce(ball):
	if ball.bounce_off(self):
		sound.play()
