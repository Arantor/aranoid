extends Node2D

var litfont
var unlitfont

func _ready():
	$Volume.value = Config.get_value("sound_volume")
	_on_volume_value_changed($Volume.value)

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	unlitfont = preload("res://Fonts/unlit-large.fnt")
	litfont = preload("res://Fonts/lit-large.fnt")
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
