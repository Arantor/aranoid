extends Node

var CurrentLevel = 0
var CurrentScore = 0
var bricks = []

# Called when the node enters the scene tree for the first time.
func begin():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	CurrentLevel = 1
	bricks = [
		false,
		preload("res://Entities/BrickGold.tscn"),
		preload("res://Entities/BrickSilver.tscn"),
		preload("res://Entities/BrickBrown.tscn"),
		preload("res://Entities/BrickRed.tscn"),
		preload("res://Entities/BrickOrange.tscn"),
		preload("res://Entities/BrickYellow.tscn"),
		preload("res://Entities/BrickGreen.tscn"),
		preload("res://Entities/BrickMintGreen.tscn"),
		preload("res://Entities/BrickLightBlue.tscn"),
		preload("res://Entities/BrickBlue.tscn"),
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

	# If no bricks left, time for next level!
	if left == 0:
		# Remove any other bricks.
		for brick in current_bricks:
			brick.queue_free()
		# Remove any balls.
		var ball_container = get_tree().get_current_scene().get_node("PlayerItems/Balls")
		var balls = ball_container.get_children()
		for ball in balls:
			ball.free()

		# And any powerups on screen.
		var powerups = get_tree().get_current_scene().get_node("Powerups").get_children()
		for powerup in powerups:
			powerup.free()

		var powerupeffects = get_tree().get_current_scene().get_node("PowerupEffects").get_children()
		for powerup in powerupeffects:
			powerup.free()

		# And nuke the player entity.
		get_tree().get_current_scene().get_node("PlayerItems/Player").free()

		# Next level, and spawn the player into it!
		CurrentLevel += 1
		var player = preload("res://Entities/Player.tscn")
		var the_player = player.instantiate()
		get_tree().get_current_scene().get_node("PlayerItems").add_child(the_player)
