extends Camera2D

var reveal = false
@export var finalOffset = -86.675
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if reveal == true and zoom >= Vector2(3,3):
		zoom -= Vector2(0.1, 0.1)
	if reveal == true and offset.y >= finalOffset:
		offset.y -= 1
	pass





func _on_boss_zoom_out():
	reveal = true
