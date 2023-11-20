extends Sprite2D

@export var player: Player
var cooldown = false
var speed = 0
var direction = Vector2(self.get_position())
var fuckRadius = Vector2(70,70)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if $Area2D.staring == true:
	#	look_at(player.get_position())
	#look_at(get_global_mouse_position())
	
	if (player.get_position() - self.get_position()) <= fuckRadius and (player.get_position() - self.get_position()) >= -fuckRadius and cooldown == false:
		look_at(player.get_position())
		cooldown = true
		print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
		var angle = self.get_rotation()
		direction = Vector2(cos(angle), sin(angle))
		self.set_position(self.get_position() + (direction * speed))
		speed = 5
	elif ((player.get_position() - self.get_position()) >= fuckRadius or (player.get_position() - self.get_position()) <= -fuckRadius) and cooldown == true:
		cooldown = false
		speed = 0
		print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
	self.set_position(self.get_position() + (direction * speed))
		
	#pass
