extends Sprite2D


var cooldown = false
var speed = 0
var direction = Vector2(self.get_position())
var fuckRadius = Vector2(150,150)
var origin = Vector2(self.get_position())
# Called when the node enters the scene tree for the first time.
func _ready():
#	var hiProfPodder = Vector2(player.get_position())
#	print("Homer says ", hiProfPodder, ", ", player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_parent().get_node("Player")
	if player != null:
		if (player.get_position() - self.get_position()) <= fuckRadius and (player.get_position() - self.get_position()) >= -fuckRadius and cooldown == false:
			look_at(player.get_position())
			cooldown = true
			print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
			var angle = self.get_rotation()
			direction = Vector2(cos(angle), sin(angle))
			speed = 2.5
			self.set_position(self.get_position() + (direction * speed * delta))
		elif ((player.get_position() - self.get_position()) >= fuckRadius or (player.get_position() - self.get_position()) <= -fuckRadius) and cooldown == true:
			cooldown = false
			speed = 0
			print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
		self.set_position(self.get_position() + (direction * speed))
	
	
#func on_damageable_hit(node : Node , damage_amount : int, knockback_direction : Vector2):
#	if node == player.Sword:


func _on_area_2d_2_body_entered(body):
	direction.x = -direction.x
