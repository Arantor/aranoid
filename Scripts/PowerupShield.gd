extends CharacterBody2D

var shield

func _ready():
	shield = preload("res://Entities/Shield.tscn")

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var powerupeffects = get_node('../../PowerupEffects')
		if powerupeffects.get_node_or_null('Shield'):
			powerupeffects.get_node('Shield').get_node('LifeTimer').start()
		else:
			var newshield = shield.instantiate()
			powerupeffects.add_child(newshield)
		queue_free()
	
	if position.y > 200:
		queue_free()
