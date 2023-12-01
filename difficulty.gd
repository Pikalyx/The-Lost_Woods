extends Node2D
@export var h : float

func _on_easy_button_button_up():
	PlayerVars.setH(20)
	PlayerVars.setCH(20)
	PlayerVars.setT(0)
	SceneTransition.change_scene_to_file("res://test_level1.tscn")


func _on_medium_button_button_up():
	PlayerVars.setH(10)
	PlayerVars.setCH(10)
	PlayerVars.setT(0)
	SceneTransition.change_scene_to_file("res://test_level1.tscn")


func _on_hard_button_button_up():
	PlayerVars.setH(5)
	PlayerVars.setCH(5)
	PlayerVars.setT(0)
	SceneTransition.change_scene_to_file("res://test_level1.tscn")


func _on_impossible_button_button_up():
	PlayerVars.setH(2)
	PlayerVars.setCH(2)
	PlayerVars.setT(0)
	SceneTransition.change_scene_to_file("res://test_level1.tscn")
