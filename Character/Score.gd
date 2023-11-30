extends Label

var score = PlayerVars.s
var score_str
 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_str = "%02d" % [score]
	$".".text = "Score: "+score_str

func updateScore(sc):
	score = sc
