extends Node


func _process(_delta):
	var lives = str(clamp(Levels.CurrentLives, 0, 99)).lpad(2)
	for digit in range(0,2):
		var digit_sprite = get_node("Digit" + str(digit + 1))
		var digit_value = lives.substr(digit, 1)
		if digit_value == " ":
			digit_sprite.set_region_rect(Rect2(0, 0, 13, 18))
		else:
			digit_sprite.set_region_rect(Rect2(0, 18 * digit_value.to_int(), 13, 18))
