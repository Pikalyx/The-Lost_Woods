extends Node2D


@onready var dtimer = $Dashtimer
@onready var ctimer = $Cooldowntimer

func start_dash(dur):
	dtimer.wait_time = dur
	dtimer.start()
	
func is_dashing():
	return !dtimer.is_stopped()

func _on_dashtimer_timeout():
	ctimer.wait_time = .5
	ctimer.start()

func is_on_cooldown():
	return ctimer.is_stopped()
