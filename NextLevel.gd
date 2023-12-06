extends Area2D


func _on_body_entered(body):
	#For testing
	#print("Level Cleared")
	var current_scene_file = get_tree().current_scene.scene_file_path
	#For testing
	
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = "res://test_level" + str(next_level_number) + ".tscn"
	
	SceneTransition.change_scene_to_file(next_level_path)


