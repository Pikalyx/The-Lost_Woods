extends Area2D


# Called when the node enters the scene tree for the first time.



func _on_body_entered(body):
	SceneTransition.change_scene_to_file("res://carter_level_1.tscn")
