extends Node2D

@onready var timer = %cooldowntimer

func start_cooldown(dur):
	timer.wait_time = dur
	timer.start()

func is_on_cooldown():
	return !timer.is_stopped()
