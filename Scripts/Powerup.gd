class_name Powerup extends Area2D

var velocity

func _physics_process(delta):
	position += velocity * delta

	if position.y > 200:
		queue_free()
