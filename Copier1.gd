extends CharacterBody2D

@export var fuckRadius = 150
@export var health = 20
@export var damage = 1
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
var closetStink = false
var reachVertex = false
var hostBody = Node2D
var copierCount : int
var unfilteredChildren : int
@export var maxCopierCount = 8
@onready var oldModulate = $Sprite2D.modulate
@export var inCloset : bool
@export var closetStinkOffset : Vector2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print("It's a new one! ", owner, self.get_global_position())
	$CopyTimer.start()
	velocity.x = 0
	velocity.y = -100
	copier = ResourceLoader.load("res://Character/copier1.tscn")
	copierCount = 0
	unfilteredChildren = get_parent().get_children().size()
	for i in get_parent().get_children().size():
		var childName = str(get_parent().get_children()[i])
		#print(childName)
		if "Copier" in childName or childName.begins_with("@CharacterBody2D"):
			copierCount += 1
	if inCloset == true:
		closetStink = true
		hide()
		for i in get_parent().get_children().size():
			var childName = str(get_parent().get_children()[i])
			#print(childName)
			if "monster_closet_detector" in childName:
				var trigger = get_parent().get_children()[i]
				trigger.body_exited.connect(_on_monster_closet_detector_body_exited)
	if player == null:
		var playerSeek = get_parent().get_parent().get_node("Player")
		if playerSeek != null:
			player = playerSeek
		else: 
			player = get_parent().get_parent().get_parent().get_node("Player")

func _physics_process(delta):
	# Add the gravity.
	if inCloset != true:
		if sticking == false:
			if not is_on_floor():
				velocity.y += gravity * delta
				if is_on_wall_only():
					direction = -direction
				if velocity.y >= 0 and reachVertex == false:
					reachVertex = true
					#$AnimationPlayer.play_backwards("Bounce")
				if player != null:
					if (player.get_position().x - self.get_global_position().x) <= fuckRadius and (player.get_position().x - self.get_global_position().x) >= -fuckRadius and (player.get_position().y - self.get_global_position().y) <= fuckRadius and (player.get_position().y - self.get_global_position().y) >= -fuckRadius:
						if unfilteredChildren != get_parent().get_children().size():
							copierCount = 0
							unfilteredChildren = get_parent().get_children().size()
							for i in get_parent().get_children().size():
								var childName = str(get_parent().get_children()[i])
								#print(childName)
								if "Copier" in childName or childName.begins_with("@CharacterBody2D"):
									copierCount += 1
							#print(get_parent().get_children())
							print("CopierCount is ", copierCount)
						if velocity.y >= 0 and cooldown == false and copier != null and health > 0 and shakeCooldown == false and $RecoilTimer.is_stopped() == true and copierCount < maxCopierCount:
							var copy = copier.instantiate()
							if closetStink == true:
								copy.closet_child()
								copy.closetStinkOffset = closetStinkOffset
							copy.set_global_position(self.get_global_position() + closetStinkOffset)
							copy.fuckRadius = fuckRadius
							print(self.get_global_position())
							#copy.set_owner(get_parent())
							get_parent().add_child(copy)
							cooldown = true
							$CopyTimer.start()

			# Handle Jump.
			if is_on_floor():
				reachVertex = false
				velocity.y = JUMP_VELOCITY
				$AnimationPlayer.play("Bounce")
				if player != null and shakeCooldown == false:
					
					if ((player.get_position().x - self.get_global_position().x) <= fuckRadius and (player.get_position().x - self.get_global_position().x) >= -fuckRadius) and ((player.get_position().y - self.get_global_position().y) <= fuckRadius and (player.get_position().y - self.get_global_position().y) >= -fuckRadius):
						#print("player is near!")
						if player.get_position().x <= self.get_global_position().x:
							direction = -1
						elif player.get_position() >= self.get_global_position():
							direction = 1
				if health <= 0:
					queue_free()
			
			
			
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			
#			if $RecoilTimer.is_stopped() == false:
#				$Sprite2D.modulate = Color(0.5,0,0)
#			else:
#				$Sprite2D.modulate = oldModulate

			move_and_slide()
		elif sticking == true:
			#$Sprite2D.modulate = oldModulate
			set_global_position((player.get_position() - stickOffset))
			if $AttackTimer.is_stopped():
				$AttackTimer.start()
			if player.sprite.flip_h != currentPlayerFlip:
				playerShakeCount += 1
				currentPlayerFlip = player.sprite.flip_h
			if playerShakeCount == 5:
				$AttackTimer.stop()
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
		health -= damage_taken
		$RecoilTimer.start()


func _on_stick_timer_timeout():
	playerShakeCount = 0
	# Replace with function body.


func _on_area_2d_body_entered(body):
	if sticking == false and shakeCooldown == false and health > 0 and $RecoilTimer.is_stopped() == true:
		sticking = true
		currentPlayerFlip = player.sprite.flip_h
		stickOffset = Vector2(player.get_position() - self.get_global_position())
		hostBody = body
		$StickTimer.start()


func _on_shake_cooldown_timer_timeout():
	shakeCooldown = false # Replace with function body.

func _on_monster_closet_detector_body_exited(body):
	show()
	inCloset = false

func closet_child():
	inCloset = false
	closetStink = true


func _on_attack_timer_timeout():
	print("Glorp!")
	if health > 0 and inCloset != true:
		for child in hostBody.get_children():
			if child is Damageable:
				print(self, " is hitting ", child)
				var direction_to_damageable = (hostBody.global_position - get_parent().global_position) 
				var direction_sign = sign(direction_to_damageable.x)

				if(direction_sign > 0):
					child.hit(damage, Vector2.RIGHT)
				elif(direction_sign < 0):
					child.hit(damage, Vector2.LEFT)
				else:
					child.hit(damage, Vector2.ZERO)
