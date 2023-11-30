extends State

@export var dead_animation_name : String = "dead"
@export var dead_state : State

func state_process(delta):
	pass

func state_input(event : InputEvent):
	pass

func on_enter():
	pass
	
func on_exit():
	pass

func _on_player_health_changed(cur):
	print("Player health is ", cur)
	if cur <= 0:
		emit_signal(("interrupt_state"), dead_state)
		playback.travel(dead_animation_name)


func _on_animation_tree_animation_finished(anim_name):
	if(anim_name == dead_animation_name):
		SceneTransition.change_scene_to_file("res://Game_Over.tscn")
