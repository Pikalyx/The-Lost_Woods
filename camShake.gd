extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0


var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

@export var shake : bool = PlayerVars.camShake
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func apply_shake():
	shake_strength = randomStrength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shake = PlayerVars.camShake
	if shake:
		print("shaking")
		apply_shake()
		#shake
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		
		offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
