extends Node2D
@export var h : float

func _on_easy_button_button_up():
	PlayerVars.setH(20)
	PlayerVars.setCH(20)
	PlayerVars.setT(0)
	PlayerVars.setSW(25)
	PlayerVars.setESM(0.5)
	SceneTransition.change_scene_to_file("res://test_level0.tscn")


func _on_medium_button_button_up():
	PlayerVars.setH(10)
	PlayerVars.setCH(10)
	PlayerVars.setT(0)
	PlayerVars.setSW(15)
	PlayerVars.setESM(1)
	SceneTransition.change_scene_to_file("res://test_level0.tscn")


func _on_hard_button_button_up():
	PlayerVars.setH(5)
	PlayerVars.setCH(5)
	PlayerVars.setT(0)
	PlayerVars.setSW(10)
	PlayerVars.setESM(1.5)
	SceneTransition.change_scene_to_file("res://test_level0.tscn")


func _on_impossible_button_button_up():
	PlayerVars.setH(2)
	PlayerVars.setCH(2)
	PlayerVars.setT(0)
	PlayerVars.setSW(5)
	PlayerVars.setESM(2)
	SceneTransition.change_scene_to_file("res://test_level0.tscn")
