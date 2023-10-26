extends Area2D

@export var player : Player

# Called when the node enters the scene tree for the first time.



func _on_body_entered(body):
	if body.name == "Player":
		get_tree().paused = true
		player.state_machine.current_state.playback.travel("idle")
		get_node("Shop/Anim").play("TransIn")
		

