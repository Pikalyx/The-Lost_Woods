extends Node2D


@onready var timer = $Dashtimer

func start_dash(dur):
	timer.wait_time = dur
	timer.start()
	
func is_dashing():
	return !timer.is_stopped()

func _on_dashtimer_timeout():
	pass # Replace with function body.
