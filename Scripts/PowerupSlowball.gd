extends CharacterBody2D

var shield

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var ball_container = get_tree().get_current_scene().get_node("PlayerItems/Balls")
		var balls = ball_container.get_children()
		var vel = sqrt((60 * 60) + (60 * 60))
		for ball in balls:
			ball.set_linear_velocity(vel)
			ball.timer = 0 # Reset the 'how long until speedup' timer
		queue_free()
	
	if position.y > 200:
		queue_free()
