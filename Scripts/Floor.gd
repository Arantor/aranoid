extends StaticBody2D


func hit(ball):
	ball.queue_free()
	balls_remaining()

func balls_remaining():
	var balls_container = get_tree().get_current_scene().get_node("PlayerItems/Balls")
	var balls = balls_container.get_children()
	
	var left = 0
	for ball in balls:
		if ball and not ball.is_queued_for_deletion():
			left += 1

	if left < 1:
		# Uh oh
		# @todo play a sound
		# @todo do an animation
		Levels.lose_life()
		var player = get_tree().get_current_scene().get_node("PlayerItems/Player")
		player.reset_player(false)
		PowerupManager.destroy_all_powerups()
