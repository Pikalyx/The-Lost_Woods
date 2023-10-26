extends ParallaxLayer

@export var MID_SPEED = -20

func _process(delta):
	self.motion_offset.x += MID_SPEED * delta
