extends Node

@export var h : float
@export var t : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setH(health: float):
	h = health

func setT(time: float):
	t = time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
