extends Node2D

var litfont
var unlitfont

# Called when the node enters the scene tree for the first time.
func _ready():
	unlitfont = preload("res://Fonts/unlit-large.fnt")
	litfont = preload("res://Fonts/lit-large.fnt")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = get_viewport().get_mouse_position()
	if pos.y >= 53 && pos.y <= 75:
		$Mainmenu/Play.label_settings.set_font(litfont)
	else:
		$Mainmenu/Play.label_settings.set_font(unlitfont)

	if pos.y >= 155 && pos.y <= 174:
		$Mainmenu/Exit.label_settings.set_font(litfont)
	else:
		$Mainmenu/Exit.label_settings.set_font(unlitfont)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if not event.is_pressed():
			return
		if event.get_button_index() != MOUSE_BUTTON_LEFT:
			return

		var pos = event.position
		if pos.y >= 53 && pos.y <= 75:
			Levels.begin()
			get_tree().change_scene_to_file("res://main.tscn")

		if pos.y >= 155 && pos.y <= 174:
			get_tree().quit()
