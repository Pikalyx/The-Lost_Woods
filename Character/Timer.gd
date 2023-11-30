extends Label

var time := 0.0
var minutes
var seconds
var milliseconds
var time_string 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	minutes = time/60
	seconds = fmod(time, 60)
	milliseconds = fmod(time, 1) * 100
	time_string = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	$".".text = "Time: "+time_string


