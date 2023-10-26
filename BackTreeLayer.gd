extends ParallaxLayer

@export var BACK_SPEED = -10

func _process(delta):
	self.motion_offset.x += BACK_SPEED * delta

