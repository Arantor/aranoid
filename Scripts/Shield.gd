extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(12, 162)


func _process(_delta):
	if $FadeOutTimer.is_stopped():
		$Shield.modulate = Color(1, 1, 1, 1 - $FadeInTimer.time_left)
	else:
		$Shield.modulate = Color(1, 1, 1, $FadeOutTimer.time_left)


func _on_fade_out_timer_timeout():
	queue_free()

# Once the life timer has expired, fade out and kill the shield.
func _on_life_timer_timeout():
	$FadeOutTimer.start()

# Start the life timer of the thing once it's faded in.
func _on_fade_in_timer_timeout():
	$LifeTimer.start()
