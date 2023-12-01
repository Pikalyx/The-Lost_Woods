extends Area2D


func _on_body_entered(body):
	#For testing
	#print("Level Cleared")
	var current_scene_file = get_tree().current_scene.scene_file_path
	#For testing
	
	
	var next_level_path = str( "res://test_level3") + ".tscn"
	
	SceneTransition.change_scene_to_file(next_level_path)


