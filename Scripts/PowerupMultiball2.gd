extends Powerup

func _on_body_entered(_body):
	var balls_container = get_node('../../PlayerItems/Balls')
	var balls = balls_container.get_children()
	for ball in balls:
		if ball.has_method("multi_split"):
			ball.call_deferred("multi_split", 2)

	var sound_effect = get_node('../../Sounds/MultiballSound')
	if not sound_effect.playing:
		sound_effect.play()
	queue_free()
