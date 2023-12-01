extends Camera2D

var reveal = false
signal doneZooming
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
		offset.y -= 100 * delta
	pass





func _on_boss_zoom_out():
	reveal = true
