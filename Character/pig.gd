extends CharacterBody2D

const movement_speed : float = 30.0
@export var fuckRadius = 150
@onready var player = get_parent().get_node("Player")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_left=true
var state = "Idle"
@export var inCloset : bool
@export var health = 30
@export var damage = 1
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
		
func _physics_process(delta):
	if inCloset != true:
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
				if ((player.get_position().x - self.get_global_position().x) <= fuckRadius and (player.get_position().x - self.get_global_position().x) >= -fuckRadius) and ((player.get_position().y - self.get_global_position().y) <= fuckRadius and (player.get_position().y - self.get_global_position().y) >= -fuckRadius):
					if player.get_position() <= self.get_global_position():
						if facing_left == false:
							scale.x = -scale.x
							facing_left = true
						velocity.x = -movement_speed


					elif player.get_position() >= self.get_global_position():
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
		if health <= 0 and state != "Dead":
			state = "Dead"
			$AnimationPlayer.play("dead")
			#print($AnimationPlayer.current_animation, ", ", $AnimationPlayer.current_animation_position, ", ", $AnimationPlayer.current_animation_length)
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
	if health > 0 and inCloset != true:
		for child in body.get_children():
			if child is Damageable:
				print(self, " is hitting ", child)
				var direction_to_damageable = (body.global_position - get_parent().global_position) 
				var direction_sign = sign(direction_to_damageable.x)

				if(direction_sign > 0):
					child.hit(damage, Vector2.RIGHT)
				elif(direction_sign < 0):
					child.hit(damage, Vector2.LEFT)
				else:
					child.hit(damage, Vector2.ZERO)


func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	state = "Hit"
	$AnimationPlayer.play("hit")
	health -= damage_taken # Replace with function body.
	
func _on_monster_closet_detector_body_exited(body):
	show()
	inCloset = false
