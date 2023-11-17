extends CharacterBody2D

const movement_speed : float = 30.0
@export var fuckRadius = 150
@onready var player = get_parent().get_node("Player")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_left=true
func _ready():
	#print("Pig thinks player is ", player)
#	var hiProfPodder = Vector2(player.get_position())
#	print("Homer says ", hiProfPodder, ", ", player)
	pass
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	detect_turn_around()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		

	if player != null:
		#print("player is not null")
		if ((player.get_position().x - self.get_position().x) <= fuckRadius and (player.get_position().x - self.get_position().x) >= -fuckRadius) and ((player.get_position().y - self.get_position().y) <= fuckRadius and (player.get_position().y - self.get_position().y) >= -fuckRadius):
			if player.get_position() <= self.get_position():
				if facing_left == false:
					scale.x = -scale.x
					facing_left = true
				velocity.x = -movement_speed


			elif player.get_position() >= self.get_position():
				velocity.x = movement_speed
				if facing_left == true:
					scale.x = -scale.x
					facing_left = false
		else:
			if facing_left:
				velocity.x = -movement_speed
			elif not facing_left:
				velocity.x = movement_speed
			
	move_and_slide()
	
func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		facing_left= !facing_left
		scale.x = -scale.x
		
