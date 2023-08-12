extends Node

@export var bar = 0.0
@export var visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func show(pos, bar_value):
	$PowerContainer.position = pos
	set_value(bar_value)

func set_value(bar_value):
	bar = bar_value
	if (bar > 0):
		visible = true
	else:
		hide()

func hide():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$PowerContainer.visible = visible
	if visible:
		var width = ceil(bar * 11) * 4 + 1
		$PowerContainer/Power.position = Vector2(floor(width / 2), 10)
		$PowerContainer/Power.set_region_rect(Rect2(0, 0, width, 19))
