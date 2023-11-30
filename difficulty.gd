extends Node2D
@export var h : float

func _on_easy_button_button_up():
	PlayerVars.setH(20)
	SceneTransition.change_scene_to_file("res://test_level1.tscn")


func _on_medium_button_button_up():
	PlayerVars.setH(10)
	SceneTransition.change_scene_to_file("res://test_level1.tscn")


func _on_hard_button_button_up():
	PlayerVars.setH(5)
	SceneTransition.change_scene_to_file("res://test_level1.tscn")


func _on_impossible_button_button_up():
	PlayerVars.setH(2)
	SceneTransition.change_scene_to_file("res://test_level1.tscn")
