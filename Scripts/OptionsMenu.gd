extends Node2D

var litfont
var unlitfont
var litfont_small
var unlitfont_small

func _ready():
	$Volume.value = Config.get_value("sound_volume")
	_on_volume_value_changed($Volume.value)
	$MouseSensitivity.value = Config.get_value("mouse_sensitivity")
	_on_mouse_sensitivity_value_changed($MouseSensitivity.value)
	
	set_game_scale(Config.get_value("scale"))

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	unlitfont = preload("res://Fonts/unlit-large.fnt")
	litfont = preload("res://Fonts/lit-large.fnt")
	
	unlitfont_small = preload("res://Fonts/unlit-small.fnt")
	litfont_small = preload("res://Fonts/lit-small.fnt")
	get_tree().paused = true

	if get_parent().name != "Mainmenu":
		$"Menu-shadow".visible = true
		$ResumeButton.visible = true
		$ResumeButton.disabled = false
		

func _on_volume_value_changed(value):
	var width = 4 + round(value) * 4
	$VolumeSliderFg.position.x = floor(142 - 38.5 + width / 2)
	$VolumeSliderFg.set_region_rect(Rect2(0, 0, width, 22))
	Config.set_value("sound_volume", round(value))


func _on_main_menu_button_mouse_entered():
	$MainMenuButton.add_theme_font_override("font", litfont)

func _on_main_menu_button_mouse_exited():
	$MainMenuButton.add_theme_font_override("font", unlitfont)

func _on_main_menu_button_pressed():
	get_tree().paused = false
	Config.save_settings()
	get_tree().change_scene_to_file("res://Entities/MainMenu.tscn")


func _on_resume_button_mouse_entered():
	$ResumeButton.add_theme_font_override("font", litfont)

func _on_resume_button_mouse_exited():
	$ResumeButton.add_theme_font_override("font", unlitfont)

func _on_resume_button_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Config.save_settings()
	queue_free()


func _on_scale_plus_mouse_entered():
	$ScalePlus.add_theme_font_override("font", litfont_small)

func _on_scale_plus_mouse_exited():
	$ScalePlus.add_theme_font_override("font", unlitfont_small)

func _on_scale_plus_pressed():
	var current_scale = Config.get_value('scale')
	if current_scale < 5:
		set_game_scale(current_scale + 1)



func _on_scale_minus_mouse_entered():
	$ScaleMinus.add_theme_font_override("font", litfont_small)

func _on_scale_minus_mouse_exited():
	$ScaleMinus.add_theme_font_override("font", unlitfont_small)

func _on_scale_minus_pressed():
	var current_scale = Config.get_value('scale')
	if current_scale > 1:
		set_game_scale(current_scale - 1)

func set_game_scale(new_scale):
	Config.set_value('scale', new_scale)
	$ScaleDisplay.text = str(new_scale)


func _on_mouse_sensitivity_value_changed(value):
	var width = 4 + round(value) * 4
	$MouseSliderFg.position.x = floor(142 - 38.5 + width / 2)
	$MouseSliderFg.set_region_rect(Rect2(0, 0, width, 22))
	Config.set_value("mouse_sensitivity", round(value))
