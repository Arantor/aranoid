extends Node2D

@export var PreviousScene = ""
@export var NextScene = ""

var litfont
var unlitfont
var screens

# Called when the node enters the scene tree for the first time.
func _ready():
	unlitfont = preload("res://Fonts/unlit-small.fnt")
	litfont = preload("res://Fonts/lit-small.fnt")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	screens = {
		'mainmenu': "res://Entities/MainMenu.tscn",
		'page1': "res://Entities/HowToPlay/HowToPlay1.tscn",
		'page2': "res://Entities/HowToPlay/HowToPlay2.tscn",
		'page3': "res://Entities/HowToPlay/HowToPlay3.tscn",
		'page4': "res://Entities/HowToPlay/HowToPlay4.tscn",
	}
	
	if PreviousScene == "":
		$Sidebar/PrevButton.visible = false
		$Sidebar/PrevButton.disabled = true

	if NextScene == "":
		$Sidebar/NextButton.visible = false
		$Sidebar/NextButton.disabled = true


func _on_prev_button_mouse_entered():
	$Sidebar/PrevButton.add_theme_font_override("font", litfont)

func _on_prev_button_mouse_exited():
	$Sidebar/PrevButton.add_theme_font_override("font", unlitfont)

func _on_prev_button_pressed():
	get_tree().change_scene_to_file(screens[PreviousScene])


func _on_next_button_mouse_entered():
	$Sidebar/NextButton.add_theme_font_override("font", litfont)

func _on_next_button_mouse_exited():
	$Sidebar/NextButton.add_theme_font_override("font", unlitfont)

func _on_next_button_pressed():
	get_tree().change_scene_to_file(screens[NextScene])
