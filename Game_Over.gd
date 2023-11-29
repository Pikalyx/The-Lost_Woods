extends Control

func _on_play_button_up():
	SceneTransition.change_scene_to_file("res://test_level1.tscn")

func _on_quit_button_up():
	get_tree().quit()
