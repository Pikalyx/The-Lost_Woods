extends Area2D

func _on_body_entered(body):
	var current_scene_file = get_tree().current_scene.scene_file_path	
	for child in body.get_children():
		if child is Damageable:
			child.hit(1, Vector2(0,0))
	if body.current_health > 0:
		SceneTransition.change_scene_to_file(current_scene_file)
	else:
		SceneTransition.change_scene_to_file("res://Game_Over.tscn")
