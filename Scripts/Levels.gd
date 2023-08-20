extends Node

var CurrentLevel = 0
var CurrentScore = 0
var CurrentLives = 3
var bricks = []

# Called when the node enters the scene tree for the first time.
func begin():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	CurrentLevel = 1
	bricks = [
		false,
		preload("res://Entities/Bricks/BrickGold.tscn"),
		preload("res://Entities/Bricks/BrickSilver.tscn"),
		preload("res://Entities/Bricks/BrickBrown.tscn"),
		preload("res://Entities/Bricks/BrickRed.tscn"),
		preload("res://Entities/Bricks/BrickOrange.tscn"),
		preload("res://Entities/Bricks/BrickYellow.tscn"),
		preload("res://Entities/Bricks/BrickGreen.tscn"),
		preload("res://Entities/Bricks/BrickMintGreen.tscn"),
		preload("res://Entities/Bricks/BrickLightBlue.tscn"),
		preload("res://Entities/Bricks/BrickBlue.tscn"),
	]

func populate_level(level):
	var level_to_build = get_level(CurrentLevel)
	for row in range(0, level_to_build.size()):
		for column in range(0, level_to_build[row].size()):
			if (level_to_build[row][column]):
				var brick = bricks[level_to_build[row][column]].instantiate()
				level.add_child(brick)
				brick.position.x = column * 7.5 + 13
				brick.position.y = row * 8 + 5

	var levelcounter = level.get_parent().get_node("PlayerItems/LevelCounter")
	var score = str(CurrentLevel).lpad(3)
	for digit in range(0,3):
		var digit_sprite = levelcounter.get_node("Digit" + str(digit + 1))
		var digit_value = score.substr(digit, 1)
		if digit_value == " ":
			digit_sprite.set_region_rect(Rect2(0, 0, 13, 18))
		else:
			digit_sprite.set_region_rect(Rect2(0, 18 * digit_value.to_int(), 13, 18))
			pass


func get_level(level):
	match level:
		1:
			return [
				[ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
				[ 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2],
				[ 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0, 9, 0,10, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0, 9],
				[ 4, 0, 5, 0, 6, 0, 7, 0, 8, 0, 9, 0,10, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0, 9, 0, 3],
				[ 5, 0, 6, 0, 7, 0, 8, 0, 9, 0,10, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0, 9, 0, 3, 0, 4],
			]
		2:
			return [
				[ 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3],
				[ 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4],
				[ 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5],
			]

	return []

func check_advance_level():
	var bricks_container = get_tree().get_current_scene().get_node("BricksContainer")
	var current_bricks = bricks_container.get_children()
	var left = 0;

	for brick in current_bricks:
		if not brick.destructible:
			continue
		if brick.hits >= 1:
			left += 1

	# If no bricks left, time for next level! If not, not yet...
	print("Bricks left: " + str(left))

	if left > 0:
		return false # We're not advancing the level

	advance_level()

	# Lastly, make sure we don't allow for spawning a powerup off the last brick!
	return true

func advance_level():
	var bricks_container = get_tree().get_current_scene().get_node("BricksContainer")
	var current_bricks = bricks_container.get_children()

	# Remove any bricks.
	for brick in current_bricks:
		print("Freeing: " + str(brick))
		brick.queue_free()

	# Remove any balls.
	var ball_container = get_tree().get_current_scene().get_node("PlayerItems/Balls")
	var balls = ball_container.get_children()
	for ball in balls:
		print("Freeing: " + str(ball))
		ball.queue_free()

	# And any powerups on screen.
	var powerups = get_tree().get_current_scene().get_node("Powerups").get_children()
	for powerup in powerups:
		print("Freeing: " + str(powerup))
		powerup.queue_free()

	var powerupeffects = get_tree().get_current_scene().get_node("PowerupEffects").get_children()
	for powerup in powerupeffects:
		if powerup.has_method("shutdown"):
			print("Shutting down: " + str(powerup))
			powerup.shutdown()

	# And reset the player entity.
	print("Resetting player")
	CurrentLevel += 1
	get_tree().get_current_scene().get_node("PlayerItems/Player").reset_player()
