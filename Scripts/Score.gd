extends Node

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node('../Player')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var score = str(player.score).lpad(5)
	for digit in range(0,5):
		var digit_sprite = get_node("Digit" + str(digit + 1))
		var digit_value = score.substr(digit, 1)
		if digit_value == " ":
			digit_sprite.set_region_rect(Rect2(0, 180, 13, 18))
		else:
			digit_sprite.set_region_rect(Rect2(0, 18 * digit_value.to_int(), 13, 18))
			pass
