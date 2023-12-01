extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
@onready var animation = $AnimationPlayer
var defaultRotation : float
const SPEED = 200
var homeSpeed : float
var ramSpeed = 500
var ramming = false
const JUMP_VELOCITY = -500
signal zoomOut
var state = "Waiting"
var entering : bool
var cooldown = false
var direction : Vector2
@export var inCloset : bool
@export var facing_left = false
@export var middleOfRoom = 825
@export var damage = 1
@export var health = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	defaultRotation = self.get_rotation()
	if inCloset == true:
		hide()
		$Imposing/ImposingShape2D.disabled = true
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
		if health > 0:
			if state == "Waiting":
				if animation.is_playing() == false:
					animation.play("idle")
					print(animation.current_animation)
				if not is_on_floor():
					velocity.y += gravity * delta
				if player.get_position() <= self.get_global_position():
					if facing_left == false:
						scale.x = -scale.x
						facing_left = true
				elif player.get_position() >= self.get_global_position():
					if facing_left == true:
						scale.x = -scale.x
						facing_left = false
					
			elif state == "Walking":
				if animation.is_playing() == false:
					animation.play("walk")
				velocity.x = SPEED
				
			elif state == "Jumping":
				if entering == true: 
					animation.play("jump")
					entering = false
				if is_on_floor():
					velocity.y = JUMP_VELOCITY
				if not is_on_floor():
					velocity.y += gravity * delta
				if not (self.get_global_position().x <= middleOfRoom +2 and self.get_global_position().x >= middleOfRoom - 2):
					if self.get_global_position().x > middleOfRoom:
						velocity.x = -SPEED
					elif self.get_global_position().x < middleOfRoom:
						velocity.x = SPEED
				else:
					velocity.x = 0
					velocity. y = 0
					state = "Homer"
					
			elif state == "Homer":
				if not is_on_floor() and not is_on_wall():
					if cooldown == false and ramming == false:
						homeSpeed = 0
						look_at(player.get_position())
						var angle = fmod(self.get_rotation(), 2 * PI)
						if abs(angle) >= PI/2:
							$Sprite2D.flip_v = true
						else:
							$Sprite2D.flip_v = false
						if $LookTimer.is_stopped() == true:
							$LookTimer.start()
					elif cooldown == false and ramming == true:
						animation.play("home")
						look_at(player.get_position())
						cooldown = true
						print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
						var angle = fmod(self.get_rotation(), 2 * PI)
						if abs(angle) >= PI/2:
							$Sprite2D.flip_v = true
							$Sprite2D.offset.y = 15.55
						else:
							$Sprite2D.flip_v = false
							$Sprite2D.offset.y = 0
						direction = Vector2(cos(angle), sin(angle))
						homeSpeed = ramSpeed
					self.set_position(self.get_position() + (direction * homeSpeed * delta))
				else:
					cooldown = false
					ramming = false
					print(self.get_rotation())
					self.rotate(defaultRotation)
					print(self.get_rotation())
					$Sprite2D.offset.y = 0
					state = "Jumping"
		else:
			if state != "Death":
				state = "Death"
				animation.play("death")
			if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length:
				queue_free()

		
	# Handle Jump

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	move_and_slide()


func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	if state == "Waiting":
		zoomOut.emit()
		$Imposing/ImposingShape2D.set_deferred("disabled", true)
	elif state == "Homer":
		direction.x = knockback_direction.x
		print(direction.y, " ", knockback_direction.y)
		direction.y = direction.y * knockback_direction.y 
		health -= damage_taken
		#deflected = true
	
func _on_monster_closet_detector_body_exited(body):
	show()
	if inCloset == true:
		inCloset = false
		$Imposing/ImposingShape2D.set_deferred("disabled", false)


func _on_camera_2d_done_zooming():
	print("Done zooming!")
	state = "Jumping"
	entering = true # Replace with function body.


func _on_area_2d_body_entered(body):
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


func _on_look_timer_timeout():
	ramming = true # Replace with function body.
