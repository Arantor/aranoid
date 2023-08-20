extends Powerup

var shield

func _ready():
	shield = preload("res://Entities/Shield.tscn")

func _on_body_entered(_body):
	var powerupeffects = get_node('../../PowerupEffects')
	if powerupeffects.get_node_or_null('Shield'):
		powerupeffects.get_node('Shield').get_node('LifeTimer').start()
	else:
		var newshield = shield.instantiate()
		powerupeffects.add_child.call_deferred(newshield)
	queue_free()
