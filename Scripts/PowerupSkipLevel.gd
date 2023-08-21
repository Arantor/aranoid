extends Powerup

func _on_body_entered(_body):
	Levels.call_deferred("advance_level")
	Levels.call_deferred("score_points", 250)
	queue_free()
