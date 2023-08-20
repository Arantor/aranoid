extends Node

var powerbar_node
var powerbar
var lifetimerdefault = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	powerbar_node = preload("res://Entities/Power.tscn")
	powerbar = powerbar_node.instantiate()
	var powerupeffects = get_node('../../PowerupEffects')
	powerupeffects.add_child(powerbar)
	powerbar.show(Vector2(267, 2), 1.0)
	lifetimerdefault = $LifeTimer.wait_time

	if $LifeTimer.is_stopped():
		$LifeTimer.start()
	var balls_container = get_node('../../PlayerItems/Balls')
	for ball in balls_container.get_children():
		if ball.has_method('set_superball'):
			ball.set_superball()

func _process(_delta):
	if $LifeTimer.is_stopped():
		powerbar.set_value(1.0)
	else:
		powerbar.set_value($LifeTimer.time_left / lifetimerdefault)

func shutdown():
	var balls_container = get_node('../../PlayerItems/Balls')
	for ball in balls_container.get_children():
		if ball.has_method('set_nonsuperball'):
			ball.set_nonsuperball()
	powerbar.queue_free()
	queue_free()

# Once the life timer has expired, fade out and kill the shield.
func _on_life_timer_timeout():
	shutdown()
