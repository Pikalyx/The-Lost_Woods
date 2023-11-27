extends CharacterBody2D

@export var fuckRadius = 150
@export var health = 2
var copier : PackedScene
const SPEED = 50
const JUMP_VELOCITY = -300.0
@onready var player = get_parent().get_node("Player")
var direction: int
var cooldown = true
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
	if not is_on_floor():
		velocity.y += gravity * delta
		if player != null:
			if ((player.get_position().x - self.get_position().x) <= fuckRadius and (player.get_position().x - self.get_position().x) >= -fuckRadius) and ((player.get_position().y - self.get_position().y) <= fuckRadius and (player.get_position().y - self.get_position().y) >= -fuckRadius):
				if velocity.y >= 0 and cooldown == false and copier != null and health > 0:
					var copy = copier.instantiate()
					copy.set_position(self.get_position())
					#copy.set_owner(get_parent())
					get_parent().add_child(copy)
					cooldown = true
					$CopyTimer.start()

	# Handle Jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		if player != null:
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


func _on_timer_timeout():
	cooldown = false
	


func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	velocity.y = JUMP_VELOCITY
	direction = -direction
	health -= 1
