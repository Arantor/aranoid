extends Powerup

func _on_body_entered(body):
	Levels.gain_life()
	queue_free()
