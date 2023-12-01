extends Node

@export var h : float = 20
@export var t : float
@export var s : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setH(health: float):
	h = health

func setT(time: float):
	t = time

func setS(score: float):
	s = score
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
