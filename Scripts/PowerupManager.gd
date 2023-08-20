extends Node

var powerups

# Called when the node enters the scene tree for the first time.
func _ready():
	powerups = {
		'shield': preload("res://Entities/Powerups/PowerupShield.tscn"),
		'slowball': preload("res://Entities/Powerups/PowerupSlowball.tscn"),
		'superball': preload("res://Entities/Powerups/PowerupSuperball.tscn"),
		'multiball': preload("res://Entities/Powerups/PowerupMultiball.tscn")
	}

func check_spawn(position):
	print("Init powerup")
	# Don't spawn a powerup if one is already on screen in motion.
	if any_powerups_present():
		return

	var powerups_container = get_tree().get_current_scene().get_node('Powerups')
	var powerup = randi_range(1, 100)
	var newpowerup = ''
	var powerup_height = 17

	if powerup > 20 and powerup <= 40:
		newpowerup = 'slowball'
		powerup_height = 21
	elif powerup > 40 and powerup <= 60:
		newpowerup = 'superball'
	elif powerup > 60 and powerup <= 80:
		newpowerup = 'multiball'
	elif powerup > 80:
		newpowerup = 'shield'

	if newpowerup:
		var newpowerup_instance = powerups[newpowerup].instantiate()
		powerups_container.add_child(newpowerup_instance)
		newpowerup_instance.position = Vector2(position.x + 7, position.y + powerup_height)
		newpowerup_instance.velocity = Vector2(0, 30)

func any_powerups_present():
	var powerups_container = get_tree().get_current_scene().get_node('Powerups')
	if powerups_container.get_child_count() > 0:
		return true

	return false
