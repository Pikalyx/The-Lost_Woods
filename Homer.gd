extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
@onready var damageable = $Damageable
var cooldown = false
var speed = 0
@export var ramSpeed: float
var direction : Vector2
@export var fuckRadius = 150
var origin = Vector2(self.get_position())
# Called when the node enters the scene tree for the first time.
func _ready():
#	var hiProfPodder = Vector2(player.get_position())
#	print("Homer says ", hiProfPodder, ", ", player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var player = get_parent().get_node("Player")
	if player != null:
		if ((player.get_position().x - self.get_position().x) <= fuckRadius and (player.get_position().x - self.get_position().x) >= -fuckRadius) and ((player.get_position().y - self.get_position().y) <= fuckRadius and (player.get_position().y - self.get_position().y) >= -fuckRadius) and cooldown == false:
			look_at(player.get_position())
			cooldown = true
			print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
			var angle = self.get_rotation()
#			print(angle)
#			if abs(angle) >= PI:
#				$AnimatedSprite2D.flip_v = true
#			else:
#				$AnimatedSprite2D.flip_v = false
			direction = Vector2(cos(angle), sin(angle))
			speed = ramSpeed
			self.set_position(self.get_position() + ((direction * speed) * delta))
		elif ((player.get_position().x - self.get_position().x) >= fuckRadius or (player.get_position().x - self.get_position().x) <= -fuckRadius or (player.get_position().y - self.get_position().y) >= fuckRadius or (player.get_position().y - self.get_position().y) <= -fuckRadius) and cooldown == true:
			cooldown = false
			speed = 0
			print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
		self.set_position(self.get_position() + (direction * speed))
	$AnimatedSprite2D.play("Homering")
	
	



func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	print("Homer hit by ", node)
	direction.x = -direction.x
