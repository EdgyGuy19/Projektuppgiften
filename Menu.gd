extends Control

var level = "res://Game.tscn"

func _on_play_pressed():
	var _level = get_tree().change_scene_to_file(level)


func _on_give_up_pressed():
	get_tree().quit()
