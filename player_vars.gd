extends Node
@export var camShake : bool = false
@export var h : float = 20
@export var t : float
@export var s : float
@export var ch : float = 20
@export var sw : int = 10
@export var esm : float = 1
@export var hs : float = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func setHS(score: float):
	if score > hs:
		hs = score
		
func setH(health: float):
	h = health

func setT(time: float):
	t = time

func setS(score: float):
	s = score
	
func setCH(current: float):
	ch = current
	
func setSW(sword: int):
	sw = sword
	
func setESM(speed: float):
	esm = speed

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if ch == 0:
		ch = h
		s = 0
		t = 0
func shake():
	camShake = true
func stopShake():
	camShake = false
		
