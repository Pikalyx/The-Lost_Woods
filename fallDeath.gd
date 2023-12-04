extends Area2D


func _on_body_entered(body):
	SceneTransition.change_scene_to_file("res://Game_Over.tscn")
