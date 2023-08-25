extends Node2D

var litfont
var unlitfont

# Called when the node enters the scene tree for the first time.
func _ready():
	unlitfont = preload("res://Fonts/unlit-large.fnt")
	litfont = preload("res://Fonts/lit-large.fnt")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _on_play_button_mouse_entered():
	$Mainmenu/PlayButton.add_theme_font_override("font", litfont)

func _on_play_button_mouse_exited():
	$Mainmenu/PlayButton.add_theme_font_override("font", unlitfont)

func _on_play_button_pressed():
	Levels.begin()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_how_to_play_button_mouse_entered():
	$Mainmenu/HowToPlayButton.add_theme_font_override("font", litfont)

func _on_how_to_play_button_mouse_exited():
	$Mainmenu/HowToPlayButton.add_theme_font_override("font", unlitfont)

func _on_how_to_play_button_pressed():
	get_tree().change_scene_to_file("res://Entities/HowToPlay/HowToPlay1.tscn")


func _on_exit_button_mouse_entered():
	$Mainmenu/ExitButton.add_theme_font_override("font", litfont)

func _on_exit_button_mouse_exited():
	$Mainmenu/ExitButton.add_theme_font_override("font", unlitfont)

func _on_exit_button_pressed():
	get_tree().quit()
