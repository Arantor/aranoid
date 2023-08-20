extends Powerup

func _on_body_entered(body):
	var ball_container = get_tree().get_current_scene().get_node("PlayerItems/Balls")
	var balls = ball_container.get_children()
	var vel = sqrt((60 * 60) + (60 * 60))
	for ball in balls:
		ball.set_linear_velocity(vel)
		ball.timer = 0 # Reset the 'how long until speedup' timer
	queue_free()
