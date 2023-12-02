extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
@onready var animation = $AnimationPlayer
const SPEED = 300
var homeSpeed : float
@export var pigSpeed = 50
var originalPigSpeed = pigSpeed
@export var ramSpeed = 500
var ramming = false
var deflected = false
const JUMP_VELOCITY = -500
signal zoomOut
var homerNext = false
var state = "Waiting"
var entering : bool
var cooldown = false
var recoilCount = 0
var direction : Vector2
@export var inCloset : bool
@export var facing_left = false
@export var middleOfRoom = 825
@export var damage = 2
@export var swordDamage = 4
@export var health = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$SwordArea.monitoring = false
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
			#print(self.get_rotation(), ", ", $Sprite2D.flip_h, ", ", $Sprite2D.flip_v)
			if state == "Waiting":
				if animation.is_playing() == false:
					animation.play("idle")
					#print(animation.current_animation)
				if not is_on_floor():
					velocity.y += gravity * delta
				if player != null:
					if player.get_position() <= self.get_global_position():
						if facing_left == false:
							scale.x = -scale.x
							facing_left = true
					elif player.get_position() >= self.get_global_position():
						if facing_left == true:
							scale.x = -scale.x
							facing_left = false
				
			elif state == "Jumping":
				if entering == true:
					animation.play("jump")
					entering = false
				elif entering == false:
					if player.get_position() <= self.get_global_position():
						$Sprite2D.flip_h = true
					elif player.get_position() >= self.get_global_position():
						$Sprite2D.flip_h = false
					if is_on_floor():
						velocity.y = JUMP_VELOCITY
					if not is_on_floor():
						velocity.y += gravity * delta
					if not (self.get_global_position().x <= middleOfRoom +4 and self.get_global_position().x >= middleOfRoom - 4):
						if self.get_global_position().x > middleOfRoom:
							velocity.x = -SPEED
						elif self.get_global_position().x < middleOfRoom:
							velocity.x = SPEED
					else:
						velocity.x = 0
						velocity. y = 0
						if homerNext == true:
							homerNext = false
							choose_state("Homer")
						else:
							choose_state("Random")
					
			elif state == "Homer":
				if entering == true:
					deflected = false
					ramming = false
					cooldown = false
					if is_on_wall():
						if self.get_global_position().x > middleOfRoom:
							self.position.x -= 10
						elif self.get_global_position().x < middleOfRoom:
							self.position.x += 10
					if is_on_floor():
						self.position.y -= 40
					if not is_on_floor() and not is_on_wall():
						entering = false
					$Sprite2D.flip_h = false
				if entering == false:
					if not is_on_floor() and not is_on_wall():
						var angle = fmod(self.get_rotation(), 2 * PI)
						if angle >= PI/2 or angle <= -PI/2:
							$Sprite2D.flip_v = true
							$Sprite2D.offset.y = 17
						else:
							$Sprite2D.flip_v = false
							$Sprite2D.offset.y = 0
						if cooldown == false and ramming == false:
							homeSpeed = 0
							look_at(player.get_position())
							#print(rotation)
							if $LookTimer.is_stopped() == true:
								$LookTimer.start()
						elif cooldown == false and ramming == true:
							#animation.play("home")
							look_at(player.get_position())
							cooldown = true
							print("cooldown is ", cooldown, (player.get_position() - self.get_position()))
							direction = Vector2(cos(angle), sin(angle))
							homeSpeed = ramSpeed
						self.set_position(self.get_position() + (direction * homeSpeed * delta))
					else:
						$Sprite2D.offset.y = 0
						if deflected == true:
							choose_state("Slump")
						else:
							choose_state("HitHome")
			
			elif state == "Pig":
				if entering == true:
					recoilCount = 0
					$AnimationPlayer.play("walk")
					entering = false
				elif entering == false and animation.is_playing() == false:
					animation.play("walk")
				if not is_on_floor():
					velocity.y += gravity * delta
				if player.get_position() <= self.get_global_position():
						if facing_left == false:
							scale.x = -scale.x
							facing_left = true
						velocity.x = -pigSpeed
				elif player.get_position() >= self.get_global_position():
					velocity.x = pigSpeed
					if facing_left == true:
						scale.x = -scale.x
						facing_left = false
				if pigSpeed < originalPigSpeed:
					pigSpeed += 50 * delta
				if recoilCount >= 5:
					choose_state("Hit")
					
			elif state == "Swing":
				velocity.x = 0
				#print($AnimationPlayer.current_animation_position)
				if not is_on_floor():
					velocity.y += gravity * delta
				if entering == true:
					entering = false
					$AnimationPlayer.play("attack")
				if $AnimationPlayer.current_animation_position > 0.9 and $AnimationPlayer.current_animation_position < 1:
					$SwordArea.monitoring = true
				else:
					$SwordArea.monitoring = false
				if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length:
					choose_state("Random")
					
			elif state == "HitHome":
				velocity.x = 0
				if not is_on_floor():
					velocity.y += gravity * delta
				if entering == true:
					animation.play("home")
					entering = false
				if $AnimationPlayer.current_animation_position > 0.3 and $AnimationPlayer.current_animation_position < 0.32:
					$SwordArea.monitoring = true
				else:
					$SwordArea.monitoring = false
				if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length:
					choose_state("Random")
			
			elif state == "Hit":
				velocity.x = 0
				if not is_on_floor():
					velocity.y += gravity * delta
				if entering == true:
					entering = false
					$AnimationPlayer.play("hit")
				if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length:
					choose_state("Slump")
					
			elif state == "Slump":
				velocity.x = 0
				if not is_on_floor():
					velocity.y += gravity * delta
				if entering == true:
					entering = false
					$AnimationPlayer.play("slump")
					$SlumpTimer.start()
					
			elif state == "Stand":
				velocity.x = 0
				if not is_on_floor():
					velocity.y += gravity * delta
				if entering == true:
					entering = false
					$AnimationPlayer.play_backwards("slump")
				if $AnimationPlayer.current_animation_position == 0:
					choose_state("Random")
				
		else:
			$Sprite2D.flip_v = false
			$Sprite2D.offset.y = 0
			if state != "Death":
				state = "Death"
				animation.play("death")
			if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length:
				queue_free()

		
	# Handle Jump

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

		move_and_slide()

func choose_state(next):
	$AnimationPlayer.stop()
	$Sprite2D.flip_h = false
	$Sprite2D.flip_v = false
	$SwordArea.monitoring = false
	entering = true
	if facing_left:
		rotation = PI
	else:
		rotation = 0
	var rng = RandomNumberGenerator.new()
	var stateNumber = rng.randi_range(0, 2)
	if next == "Random":
		if stateNumber == 0:
			state = "Pig"
		elif stateNumber == 1:
			homerNext = true
			state = "Jumping"
		elif stateNumber == 2:
			state = "Jumping"
	else:
		state = next
	print(state)

func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	if state == "Waiting":
		zoomOut.emit()
		$Imposing/ImposingShape2D.set_deferred("disabled", true)
	elif state == "Homer":
		direction.x = knockback_direction.x
		print(direction.y, " ", knockback_direction.y)
		direction.y = direction.y * knockback_direction.y 
		health -= damage_taken
		deflected = true
	elif state == "Pig":
		if $PigRecoilTimer.is_stopped() == true:
			$PigRecoilTimer.start()
		if recoilCount < 5:
			recoilCount += 1
			pigSpeed = -pigSpeed/2
		else:
			health -= damage_taken
	elif state == "Slump":
		$AnimationPlayer.play("slumphit")
		health -= damage_taken
	
func _on_monster_closet_detector_body_exited(body):
	show()
	if inCloset == true:
		inCloset = false
		$Imposing/ImposingShape2D.set_deferred("disabled", false)


func _on_camera_2d_done_zooming():
	print("Done zooming!")
	choose_state("Jumping")
	entering = true # Replace with function body.


func _on_area_2d_body_entered(body):
	if health > 0 and inCloset != true:
		if (state == "Jumping" or state == "Homer"):
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
		if state == "Pig":
			choose_state("Swing")


func _on_look_timer_timeout():
	ramming = true # Replace with function body.


func _on_pig_recoil_timer_timeout():
	if recoilCount < 5 and state == "Pig":
		choose_state("Swing")


func _on_slump_timer_timeout():
	if health > 0:
		choose_state("Stand") # Replace with function body.


func _on_sword_area_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			print(self, " is hitting ", child)
			var direction_to_damageable = (body.global_position - get_parent().global_position) 
			var direction_sign = sign(direction_to_damageable.x)

			if(direction_sign > 0):
				child.hit(swordDamage, Vector2.RIGHT)
			elif(direction_sign < 0):
				child.hit(swordDamage, Vector2.LEFT)
			else:
				child.hit(swordDamage, Vector2.ZERO)
