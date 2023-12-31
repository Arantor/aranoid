extends StaticBody2D

var powerbar_node
var powerbar
var lifetimerdefault = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(12, 162)
	powerbar_node = preload("res://Entities/Power.tscn")
	powerbar = powerbar_node.instantiate()
	var powerupeffects = get_node('../../PowerupEffects')
	powerupeffects.add_child(powerbar)
	powerbar.show(Vector2(267, 25), 1.0)
	lifetimerdefault = $LifeTimer.wait_time
	$SoundUp.play()

func _process(_delta):
	if $FadeOutTimer.is_stopped():
		$Shield.modulate = Color(1, 1, 1, 1 - $FadeInTimer.time_left)
		if $LifeTimer.is_stopped():
			powerbar.set_value(1.0)
		else:
			powerbar.set_value($LifeTimer.time_left / lifetimerdefault)
	else:
		$Shield.modulate = Color(1, 1, 1, $FadeOutTimer.time_left)
		powerbar.hide()

func shutdown():
	powerbar.queue_free()
	queue_free()

func _on_fade_out_timer_timeout():
	shutdown()

# Once the life timer has expired, fade out and kill the shield.
func _on_life_timer_timeout():
	$FadeOutTimer.start()
	$SoundDown.play()

# Start the life timer of the thing once it's faded in.
func _on_fade_in_timer_timeout():
	$LifeTimer.start()

func hit(_ball, _collision):
	if not $SoundBounce.playing:
		$SoundBounce.play()
	return false # We aren't handling the bounce
