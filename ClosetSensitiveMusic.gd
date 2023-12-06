extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_camera_2d_done_zooming():
	play()# Replace with function body.


func _on_closet_door_closed():
	stop() # Replace with function body.


func _on_monster_closet_detector_body_exited(body):
	if autoplay == true:
		stop()
	elif autoplay == false:
		if playing == false:
			play()
