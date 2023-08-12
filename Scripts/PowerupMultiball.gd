extends CharacterBody2D

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var balls_container = get_node('../../PlayerItems/Balls')
		var balls = balls_container.get_children()
		for ball in balls:
			if ball.has_method("multi_split"):
				ball.multi_split(3)

		var sound_effect = get_node('../../Sounds/MultiballSound')
		if not sound_effect.playing:
			sound_effect.play()
		queue_free()
	
	if position.y > 200:
		queue_free()
