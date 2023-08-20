extends Powerup

func _on_body_entered(_body):
	Levels.gain_life()
	queue_free()
