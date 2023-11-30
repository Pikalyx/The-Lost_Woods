extends Node2D


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")



func _on_mute_button_button_up():
	var bus_idx = AudioServer.get_bus_index("Master")
	if(AudioServer.is_bus_mute(bus_idx)):
		AudioServer.set_bus_mute(bus_idx, false)
	else: 
		AudioServer.set_bus_mute(bus_idx, true)



func _on_controls_button_button_up():
	get_tree().change_scene_to_file("res://controls.tscn")
