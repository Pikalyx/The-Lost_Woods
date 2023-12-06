extends Area2D


func _on_body_entered(body):
	if body is Player:
		SceneTransition.change_scene_to_file("res://Game_Over.tscn")
	else:
		body.queue_free()
