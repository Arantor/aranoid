extends Node


# Called when the node enters the scene tree for the first time.
func do_game_over():
	PowerupManager.destroy_all_powerups()
	Levels.GameOver = true
	$GameOver.visible = true
	$GameOver2.visible = true
	$Timer.start()


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Entities/MainMenu.tscn")
