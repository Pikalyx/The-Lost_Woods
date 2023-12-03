extends Area2D




const lines: Array[String] = [
	""
]

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if interaction_area.get_overlapping_bodies().size() > 0:
			DialogManager.start_dialog(global_position,lines)
