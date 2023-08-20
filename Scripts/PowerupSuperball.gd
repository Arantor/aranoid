extends CharacterBody2D

var superball

func _ready():
	superball = preload("res://Entities/Superball.tscn")

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var powerupeffects = get_node('../../PowerupEffects')
		if powerupeffects.get_node_or_null('Superball'):
			powerupeffects.get_node('Superball').get_node('LifeTimer').start()
		else:
			var newsuperball = superball.instantiate()
			powerupeffects.add_child(newsuperball)
		queue_free()
	
	if position.y > 200:
		queue_free()
