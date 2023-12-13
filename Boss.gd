extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
@onready var defaultModulate = $Sprite2D.modulate
@onready var animation = $AnimationPlayer
const SPEED = 300
var homeSpeed : float
@export var pigSpeed = 50
var originalPigSpeed = pigSpeed
@export var ramSpeed = 500
@export var dashSpeed = 400
var ramming = false
var deflected = false
const JUMP_VELOCITY = -500
signal zoomOut
var homerNext = false
var summonNext = false
var state = "Waiting"
var entering : bool
var cooldown = false
var recoilCount = 0
var topEnd : float
var bottomEnd : float
var reachedTop : bool
var reachedBottom : bool
var instanter : PackedScene
var collected = false
var wipe = false
var direction : Vector2
@export var inCloset : bool
@export var facing_left = false
@export var middleOfRoom = 825
@export var halfwayUpRoom = -25
@export var homerDamage = 2
@export var summonDamage = 1
@export var swordDamage = 3
@export var health = 450
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
	
func _process(delta):
	PlayerVars.setBH(health)
					
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
					if not (self.get_global_position().x <= middleOfRoom +4 and self.get_global_position().x >= middleOfRoom - 4 and self.get_global_position().y <= halfwayUpRoom):
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
						elif summonNext == true:
							summonNext = false
							choose_state("Summon")
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
						if facing_left:
							rotation = PI
						else:
							rotation = 0
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
				$Sprite2D.modulate = defaultModulate + Color(recoilCount, 0, recoilCount)
				if recoilCount >= 5:
					choose_state("Hit")
					
			elif state == "Summon":
				velocity.x = 0
				if entering == true:
					$AnimationPlayer.play("attack")
					if self.get_global_position().y < halfwayUpRoom:
						velocity.y += gravity * delta
					else:
						topEnd = self.get_global_position().y -20
						bottomEnd = self.get_global_position().y +20
						reachedTop = true
						reachedBottom = false
						velocity.y = 0
						entering = false
#						print(topEnd)
#						print(bottomEnd)
						instanter = ResourceLoader.load("res://boss_sphere.tscn")
						$Imposing/ImposingShape2D.set_deferred("disabled", false)
						var copy = instanter.instantiate()
						get_parent().add_child(copy)
						$SummonTimer.start()
				elif entering == false:
					if $AnimationPlayer.current_animation == "attack" and $AnimationPlayer.current_animation_position > 0.8:
						$AnimationPlayer.play("charge")
					elif $AnimationPlayer.current_animation != "attack" and $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length and not $SummonTimer.is_stopped():
						$AnimationPlayer.play("charge")
					elif $AnimationPlayer.current_animation != "attack" and $SummonTimer.is_stopped():
						$AnimationPlayer.play("home")
					var unfilteredChildren = get_parent().get_children().size()
					var childName = str(get_parent().get_children())
#					print(childName)
					if "BossSphere" not in childName:
						collected = true
					if self.get_global_position().y > topEnd and reachedTop == false:
						velocity.y = -4000 * delta
					elif self.get_global_position().y <= topEnd and reachedTop == false:
						reachedTop = true
						reachedBottom = false
					elif self.get_global_position().y <= bottomEnd and reachedBottom == false:
						velocity.y = 4000 * delta
					elif self.get_global_position().y >= bottomEnd and reachedBottom == false:
						reachedBottom = true
						reachedTop = false
					if collected == true:
						$SummonTimer.stop()
						$Imposing/ImposingShape2D.set_deferred("disabled", true)
						choose_state("Slump")
			
			elif state == "Dash":
				if entering == true:
					velocity.x = 0
					if is_on_wall():
						if self.get_global_position().x > middleOfRoom:
							self.position.x -= 10
						elif self.get_global_position().x < middleOfRoom:
							self.position.x += 10
					$AnimationPlayer.play("dashWind")
					if animation.current_animation_position >= 0.5:
						entering = false
						animation.play("dash")
						$SwordArea.monitoring = true
				else:
					if animation.current_animation_position == animation.current_animation_length:
						animation.play("dash")
					if not is_on_wall():
						if facing_left:
							velocity.x = -dashSpeed
						else:
							velocity.x = dashSpeed
					else:
						$SwordArea.monitoring = false
						choose_state("Random")
			
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
			
			elif state == "Copy":
				if entering == true:
					var childName = str(get_parent().get_children())
#					print(childName)
					if "Copy" not in childName and $CopyTimer.is_stopped() == true:
						if not is_on_floor():
							velocity.y += gravity * delta
						else:
							entering = false
							$AnimationPlayer.play("Boss/copy")
					else:
						choose_state("Random")
				elif entering == false:
					if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length:
							var copier = ResourceLoader.load("res://boss_copy.tscn")
							var copy = copier.instantiate()
							copy.set_position(self.get_position())
							get_parent().add_child(copy)
							print(get_parent().get_children())
							$CopyTimer.start()
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
				$Sprite2D.modulate = defaultModulate + Color(5, 0, 5)
				velocity.x = 0
				if not is_on_floor():
					velocity.y += gravity * delta
				if entering == true:
					entering = false
					$AnimationPlayer.play("hit")
				if $AnimationPlayer.current_animation_position >= 0.1:
					$Sprite2D.modulate = defaultModulate
				if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length:
					choose_state("Slump")
			
			elif state == "Clash":
				velocity.x = 0
				if not is_on_floor():
					velocity.y += gravity * delta
				if entering == true:
					entering = false
					$AnimationPlayer.play("clash")
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
			
			if wipe == true:
				for child in player.get_children():
					if child is Damageable:
						print(self, " is hitting ", child)
						var direction_to_damageable = (player.global_position - get_parent().global_position) 
						var direction_sign = sign(direction_to_damageable.x)

						if(direction_sign > 0):
							child.hit(99999, Vector2.RIGHT)
						elif(direction_sign < 0):
							child.hit(99999, Vector2.LEFT)
						else:
							child.hit(99999, Vector2.ZERO)
				
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
	$StateInvulnTimer.start()
	#$AnimationPlayer.stop()
	$Sprite2D.flip_h = false
	$Sprite2D.flip_v = false
	$SwordArea.monitoring = false
	$Sprite2D.modulate = Color(defaultModulate)
	collected = false
	entering = true
	if player.get_position() <= self.get_global_position():
		if facing_left == false:
			scale.x = -scale.x
			facing_left = true
	elif player.get_position() >= self.get_global_position():
		if facing_left == true:
			scale.x = -scale.x
			facing_left = false
	var rng = RandomNumberGenerator.new()
	var stateNumber = rng.randi_range(0, 5)
	if next == "Random":
		if stateNumber == 0:
			state = "Pig"
		elif stateNumber == 1:
			homerNext = true
			state = "Jumping"
		elif stateNumber == 2:
			summonNext = true
			state = "Jumping"
		elif stateNumber == 3:
			state = "Jumping"
		elif stateNumber == 4:
			state = "Dash"
		elif stateNumber == 5:
			state = "Copy"
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
	elif state == "Pig" and $StateInvulnTimer.is_stopped():
		if $PigRecoilTimer.is_stopped() == true:
			$PigRecoilTimer.start()
		if recoilCount < 5:
			recoilCount += 1
			pigSpeed = -pigSpeed/2
		else:
			health -= damage_taken
	elif state == "Dash":
		pass
	elif state == "Slump":
		$AnimationPlayer.play("slumphit")
		health -= damage_taken
	elif state == "Copy" and $StateInvulnTimer.is_stopped():
		health -= damage_taken
		choose_state("Hit")
	
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
	var damage : int
	if health > 0 and inCloset != true:
		if state == "Homer":
			damage = homerDamage
		elif state == "Summon":
			damage = summonDamage
		if damage != 0:
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
	var sliceDamage : int
	if state != "Swing":
		sliceDamage = swordDamage -1
	else:
		sliceDamage = swordDamage
	for child in body.get_children():
		if child is Damageable:
			print("Boss Sword is hitting ", child)
			var direction_to_damageable = (body.global_position - get_parent().global_position) 
			var direction_sign = sign(direction_to_damageable.x)

			if(direction_sign > 0):
				child.hit(sliceDamage, Vector2.RIGHT)
			elif(direction_sign < 0):
				child.hit(sliceDamage, Vector2.LEFT)
			else:
				child.hit(sliceDamage, Vector2.ZERO)


func _on_summon_timer_timeout():
	if state == "Summon":
		wipe = true


func _on_sword_damageable_on_hit(node, damage_taken, knockback_direction):
	if state == "Dash" and $StateInvulnTimer.is_stopped():
		choose_state("Clash")
