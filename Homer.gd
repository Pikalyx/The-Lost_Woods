extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
@onready var damageable = $Damageable
var cooldown = false
var speed = 0
@export var ramSpeed: float
var direction : Vector2
@export var fuckRadius = 150
@export var health = 0
@export var inCloset : bool
var origin = Vector2(self.get_position())
var attackTopCorner : Vector2
var attackBottomCorner : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	if inCloset == true:
		hide()
		var trigger = get_parent().get_node("monster_closet_detector")
		trigger.body_exited.connect(_on_monster_closet_detector_body_exited)
		if player == null:
			var playerSeek = get_parent().get_parent().get_node("Player")
			if playerSeek != null:
				player = playerSeek
			else:
				player = get_parent().get_parent().get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var player = get_parent().get_node("Player")
	if inCloset != true:
		if player != null:
			if ((player.get_position().x - self.get_global_position().x) <= fuckRadius and (player.get_position().x - self.get_global_position().x) >= -fuckRadius) and ((player.get_position().y - self.get_global_position().y) <= fuckRadius and (player.get_position().y - self.get_global_position().y) >= -fuckRadius) and cooldown == false:
				attackTopCorner = Vector2((self.get_global_position().x - fuckRadius), (self.get_global_position().y - fuckRadius))
				attackBottomCorner = Vector2((self.get_global_position().x + fuckRadius), (self.get_global_position().y + fuckRadius))
				look_at(player.get_position())
				cooldown = true
				print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
				var angle = fmod(self.get_rotation(), 2 * PI)
				if abs(angle) >= PI/2:
					$AnimatedSprite2D.flip_v = true
				else:
					$AnimatedSprite2D.flip_v = false
				direction = Vector2(cos(angle), sin(angle))
				speed = ramSpeed
				self.set_position(self.get_position() + ((direction * speed)))
			elif (((player.get_position().x - self.get_global_position().x) >= fuckRadius or (player.get_position().x - self.get_global_position().x) <= -fuckRadius or (player.get_position().y - self.get_global_position().y) >= fuckRadius or ((player.get_position().y - self.get_global_position().y) <= -fuckRadius) and cooldown == true) or ((attackTopCorner.x - self.get_global_position().x) >= fuckRadius or (attackBottomCorner.x - self.get_global_position().x) <= -fuckRadius or (attackTopCorner.y - self.get_global_position().y) >= fuckRadius or (attackBottomCorner.y - self.get_global_position().y) <= -fuckRadius)) and cooldown == true:
				cooldown = false
				speed = 0
				if health <= 0:
					queue_free()
				print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
			self.set_position(self.get_position() + (direction * speed))
		$AnimatedSprite2D.play("Homering")
	
	

func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	print("Homer hit by ", node)
	direction.x = -direction.x
	health -= 1

func _on_monster_closet_detector_body_exited(body):
	show()
	inCloset = false
