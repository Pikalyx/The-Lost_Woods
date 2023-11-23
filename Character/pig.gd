extends CharacterBody2D

const movement_speed : float = 30.0
@export var fuckRadius = 150
@onready var player = get_parent().get_node("Player")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_left=true
var state = "Idle"
@export var health = 3
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
	if state == "Idle":
		if $AnimationPlayer.is_playing() == false:
			$AnimationPlayer.play("run")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions
		#print("player is not null")
		if player != null:
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
	if health <= 0:
		state = "Dead"
		$AnimationPlayer.play("dead")
	if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length and state == "Attacking":
		state = "Idle"
	if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length and state == "Hit":
		state = "Idle"
	if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length and state == "Dead":
		queue_free()
#	print(state)
	#print($AnimationPlayer.current_animation, ", ", $AnimationPlayer.current_animation_position, ", ", $AnimationPlayer.current_animation_length)
		#print("pig attack done")
	
	
func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		facing_left= !facing_left
		scale.x = -scale.x
		


func _on_area_2d_body_entered(body):
	state = "Attacking"
	$AnimationPlayer.play("attack")


func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	state = "Hit"
	$AnimationPlayer.play("hit")
	health -= 1 # Replace with function body.
