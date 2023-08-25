extends Node2D

var litfont
var unlitfont

func _ready():
	$Volume.value = 18
	_on_volume_value_changed(18)

	unlitfont = preload("res://Fonts/unlit-large.fnt")
	litfont = preload("res://Fonts/lit-large.fnt")
	get_tree().paused = true

func _on_volume_value_changed(value):
	var width = 4 + round(value) * 4
	$VolumeSliderFg.position.x = floor(142 - 38.5 + width / 2)
	$VolumeSliderFg.set_region_rect(Rect2(0, 0, width, 22))


func _on_main_menu_button_mouse_entered():
	$MainMenuButton.add_theme_font_override("font", litfont)

func _on_main_menu_button_mouse_exited():
	$MainMenuButton.add_theme_font_override("font", unlitfont)

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Entities/MainMenu.tscn")
