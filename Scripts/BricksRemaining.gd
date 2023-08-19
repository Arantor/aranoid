extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bricks_container = get_tree().get_current_scene().get_node("BricksContainer")
	var current_bricks = bricks_container.get_children()
	var left = 0;
	for brick in current_bricks:
		if not brick.destructible:
			continue
		if brick.hits >= 1:
			left += 1

	var score = str(left).lpad(3)
	for digit in range(0,3):
		var digit_sprite = get_node("Digit" + str(digit + 1))
		var digit_value = score.substr(digit, 1)
		if digit_value == " ":
			digit_sprite.set_region_rect(Rect2(0, 180, 13, 18))
		else:
			digit_sprite.set_region_rect(Rect2(0, 18 * digit_value.to_int(), 13, 18))
			pass