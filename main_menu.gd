extends Node2D

func _on_new_game_button_button_up():
	SceneTransition.change_scene_to_file("res://test_level1.tscn")


func _on_credits_button_button_up():
	get_tree().change_scene_to_file("res://credits_page.tscn")


func _on_settings_button_button_up():
	get_tree().change_scene_to_file("res://settings_page.tscn")


func _on_texture_button_button_up():
	SceneTransition.change_scene_to_file("res://test_level1.tscn")


func _on_quit_button_button_up():
	get_tree().quit()
