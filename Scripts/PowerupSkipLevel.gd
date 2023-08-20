extends Powerup

func _on_body_entered(_body):
	Levels.call_deferred("advance_level")
	queue_free()
