extends Node2D

var litfont
var unlitfont

# Called when the node enters the scene tree for the first time.
func _ready():
	unlitfont = preload("res://Fonts/unlit-small.fnt")
	litfont = preload("res://Fonts/lit-small.fnt")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var pos = get_viewport().get_mouse_position()
	
	if (pos.x >= 250 && pos.y >= 114) && (pos.x <= 310 && pos.y <= 136):
		$Sidebar/Prev.label_settings.set_font(litfont)
	else:
		$Sidebar/Prev.label_settings.set_font(unlitfont)

	if (pos.x >= 250 && pos.y >= 156) && (pos.x <= 310 && pos.y <= 176):
		$Sidebar/Next.label_settings.set_font(litfont)
	else:
		$Sidebar/Next.label_settings.set_font(unlitfont)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if not event.is_pressed():
			return
		if event.get_button_index() != MOUSE_BUTTON_LEFT:
			return

		var pos = event.position
		if (pos.x >= 250 && pos.y >= 114) && (pos.x <= 310 && pos.y <= 136):
			get_tree().change_scene_to_file("res://Entities/HowToPlay/HowToPlay3.tscn")

		if (pos.x >= 250 && pos.y >= 156) && (pos.x <= 310 && pos.y <= 176):
			pass #get_tree().change_scene_to_file("res://Entities/HowToPlay3.tscn")
