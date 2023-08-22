extends Node

var NewLifeAt = 500.0
var CurrentLevel = 0
var CurrentScore = 0
var CurrentLives = 3
var GameOver = false
var bricks = []
var level_scenes

# Called when the node enters the scene tree for the first time.
func _ready():
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
	level_scenes = {
		'earth': preload("res://Entities/Levels/LevelEarth.tscn"),
		'offbyone': preload("res://Entities/Levels/LevelOffByOne.tscn"),
		'spine': preload("res://Entities/Levels/LevelSpine.tscn"),
		'treasurechest': preload("res://Entities/Levels/LevelTreasureChest.tscn"),
		'weave': preload("res://Entities/Levels/LevelWeave.tscn"),
	}

func begin():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	CurrentLevel = 1
	CurrentScore = 0
	CurrentLives = 3
	GameOver = false

func populate_level(level):
	var level_to_build = get_level(CurrentLevel)
	for brick in level_to_build.get_children():
		level_to_build.remove_child(brick)
		level.add_child(brick)

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

func build_level_from_array(level_to_build):
	var level = Node2D.new()
	for row in range(0, level_to_build.size()):
		for column in range(0, level_to_build[row].size()):
			if (level_to_build[row][column]):
				var brick = bricks[level_to_build[row][column]].instantiate()
				level.add_child(brick)
				brick.position.x = column * 7.5 + 13
				brick.position.y = row * 8 + 5

	return level

func build_level_from_packed_scene(level_to_build):
	var level = level_scenes[level_to_build].instantiate()
	for brick in level.get_children():
		brick.position += Vector2(13, 5)

	return level

func get_level(level):
	
	var levels = [
		'spine',
		'earth',
		'treasurechest',
		'offbyone',
		'weave',
		false
	]
	level = (level - 1) % levels.size()
	
	if levels[level]:
		return build_level_from_packed_scene(levels[level])

	return build_level_from_array([
		[ 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3],
		[ 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4],
		[ 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5],
	])

func get_remaining_brick_count():
	var bricks_container = get_tree().get_current_scene().get_node("BricksContainer")
	var current_bricks = bricks_container.get_children()
	var left = 0
	var destructible = 0
	var queued = 0

	for brick in current_bricks:
		if brick.is_queued_for_deletion():
			queued += 1
			continue
		if not brick.destructible:
			destructible += 1
			continue
		if brick.hits >= 1:
			left += 1

	# If no bricks left, time for next level! If not, not yet...
	#print("Bricks left: " + str(left) + ", nondestruct: " + str(destructible) + ", queued: " + str(queued))
	return left

func check_advance_level():
	var left = get_remaining_brick_count()
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
	PowerupManager.destroy_all_powerups()

	# And reset the player entity.
	print("Resetting player")
	CurrentLevel += 1
	get_tree().get_current_scene().get_node("PlayerItems/Player").reset_player()

func score_points(points):
	print("Applying score")
	var beforescore = CurrentScore
	CurrentScore += points
	if floorf(CurrentScore / NewLifeAt) > floorf(beforescore / NewLifeAt):
		gain_life()

func gain_life():
	# @todo play sound
	CurrentLives += 1

func lose_life():
	CurrentLives -= 1
	if CurrentLives < 1:
		var gameover = get_tree().get_current_scene().get_node("PlayerItems/GameOver")
		gameover.do_game_over()
