extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 100
var shake_strength: float = 0.0
var rng = RandomNumberGenerator.new()

var reveal = false
signal doneZooming
@onready var summonTimer = get_parent().get_node("ClosetDoor/Boss/SummonTimer")
@export var finalOffset = -86.675
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if reveal == true and zoom >= Vector2(3,3):
		zoom -= Vector2(8 * delta, 8 * delta)
	elif reveal == true and zoom <= Vector2(3,3):
		doneZooming.emit()
		reveal = false
	if reveal == true and offset.y >= finalOffset:
		offset.y -= 150 * delta
	if summonTimer != null:
		if summonTimer.is_stopped() == false:
			shake_strength = 1.5
			offset = randomOffset()
			#shake
		if shake_strength > 0 and summonTimer.is_stopped():
			shake_strength = 0

func randomOffset() -> Vector2:
	return Vector2(0, finalOffset) + Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))


func _on_boss_zoom_out():
	reveal = true
