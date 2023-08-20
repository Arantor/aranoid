extends CharacterBody2D

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		Levels.gain_life()
		queue_free()
	
	if position.y > 200:
		queue_free()
