extends Powerup

var superball

func _ready():
	superball = preload("res://Entities/Superball.tscn")

func _on_body_entered(_body):
	var powerupeffects = get_node('../../PowerupEffects')
	if powerupeffects.get_node_or_null('Superball'):
		powerupeffects.get_node('Superball').get_node('LifeTimer').start()
	else:
		var newsuperball = superball.instantiate()
		powerupeffects.add_child(newsuperball)
	queue_free()
