extends CharacterBody2D

@export var fuckRadius = 150
@export var health = 2
var copier : PackedScene
const SPEED = 50
const JUMP_VELOCITY = -300.0
@onready var player = get_parent().get_node("Player")
var direction: int
var cooldown = true
var sticking = false
var currentPlayerFlip : bool
var playerShakeCount = 0
var shakeCooldown = false
var stickOffset : Vector2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print("It's a new one! ", owner)
	$CopyTimer.start()
	velocity.x = 0
	velocity.y = -100
	copier = ResourceLoader.load("res://Character/copier1.tscn")
	

func _physics_process(delta):
	# Add the gravity.
	if sticking == false:
		if not is_on_floor():
			velocity.y += gravity * delta
			if is_on_wall_only():
				direction = -direction
			if player != null:
				if ((player.get_position().x - self.get_position().x) <= fuckRadius and (player.get_position().x - self.get_position().x) >= -fuckRadius) and ((player.get_position().y - self.get_position().y) <= fuckRadius and (player.get_position().y - self.get_position().y) >= -fuckRadius):
					if velocity.y >= 0 and cooldown == false and copier != null and health > 0 and shakeCooldown == false:
						var copy = copier.instantiate()
						copy.set_position(self.get_position())
						#copy.set_owner(get_parent())
						get_parent().add_child(copy)
						cooldown = true
						$CopyTimer.start()

		# Handle Jump.
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			if player != null and shakeCooldown == false:
				if ((player.get_position().x - self.get_position().x) <= fuckRadius and (player.get_position().x - self.get_position().x) >= -fuckRadius) and ((player.get_position().y - self.get_position().y) <= fuckRadius and (player.get_position().y - self.get_position().y) >= -fuckRadius):
					if player.get_position().x <= self.get_position().x:
						direction = -1
					elif player.get_position() >= self.get_position():
						direction = 1
			if health <= 0:
				queue_free()
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		

		move_and_slide()
	elif sticking == true:
		set_position((player.get_position() - stickOffset))
		
		if player.sprite.flip_h != currentPlayerFlip:
			playerShakeCount += 1
			currentPlayerFlip = player.sprite.flip_h
		if playerShakeCount == 5:
			sticking = false
			velocity.y = JUMP_VELOCITY
			shakeCooldown = true
			$ShakeCooldownTimer.start()
		
		move_and_slide()

func _on_timer_timeout():
	cooldown = false
	


func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	if sticking == false:
		velocity.y = JUMP_VELOCITY
		direction = -direction
		health -= 1


func _on_stick_timer_timeout():
	playerShakeCount = 0
	# Replace with function body.


func _on_area_2d_body_entered(body):
	if sticking == false and shakeCooldown == false and health > 0:
		sticking = true
		currentPlayerFlip = player.sprite.flip_h
		stickOffset = Vector2(player.get_position() - self.get_position())
		$StickTimer.start()


func _on_shake_cooldown_timer_timeout():
	shakeCooldown = false # Replace with function body.
