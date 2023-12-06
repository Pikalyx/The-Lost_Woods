extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var score_str = "%02d" % [PlayerVars.s]
	var time_str = "%02d" % [PlayerVars.t]
	$MarginContainer/VBoxContainer/scoreHolder/Score_Label.text = "High Score: "+score_str
	$MarginContainer/VBoxContainer/timeHolder/Timer_Label.text = "Time: "+time_str
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
