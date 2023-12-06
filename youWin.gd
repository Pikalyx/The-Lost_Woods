extends Node2D



func _ready():
	var score_str = "%02d" % [PlayerVars.s]
	var time_str = "%02d" % [PlayerVars.t]
	$MarginContainer/VBoxContainer/scoreHolder/Score_Label.text = "High Score: "+score_str
	$MarginContainer/VBoxContainer/timeHolder/Timer_Label.text = "Time: "+time_str
	pass 

func _on_quit_button_button_up():
	get_tree().quit() 
