extends ParallaxLayer

@export var CLOSE_SPEED = -40

func _process(delta):
	self.motion_offset.x += CLOSE_SPEED * delta
