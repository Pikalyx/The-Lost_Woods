extends CharacterBody2D

var stalkOffset : float
@export var state : String = "Launch"
@export var damage = 1
var directionCommit : float
var homeSpeed = 600
var cooldown = false
var direction : Vector2
var angle : float
var entering : bool
var throbCount = 0
var maxThrobCount = 10
@onready var player = get_parent().get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == "Launch":
		if not is_on_floor() and not is_on_wall():
			if cooldown == false:
				look_at(player.get_position())
				angle = fmod(self.get_rotation(), 2 * PI)
				direction = Vector2(cos(angle), sin(angle))
				if angle >= PI/2 or angle <= -PI/2:
					$Sprite2D.flip_v = true
				else:
					$Sprite2D.flip_v = false
			#animation.play("home")
				cooldown = true
				print("Trailer cooldown is ", cooldown, (player.get_position() - self.get_position()))
			self.set_position(self.get_position() + (direction * homeSpeed * delta))
		else:
			queue_free()
			print("Trailer die!")
		move_and_slide()

	elif state == "Latch":
		if entering == true:
			$Sprite2D.flip_v = false
			$AnimationPlayer.play("throb")
			self.set_position(Vector2(player.get_position().x - 25, player.get_position().y))
			look_at(player.get_position())
			entering = false
		#var player = get_parent().get_node("Player")
		elif entering == false:
			if not is_on_floor() and not is_on_ceiling() or is_on_wall_only():
				if player.sprite.flip_h == false:
					stalkOffset = (player.get_position().x - 25)
				elif player.sprite.flip_h == true:
					stalkOffset = (player.get_position().x + 25)
				self.set_position(Vector2(stalkOffset, player.get_position().y))
			else:
				$AnimationPlayer.pause()
				if $Timer.is_stopped() == true:
					$Timer.start()
			if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length:
				$AnimationPlayer.play("throb")
				throbCount += 1
				print(throbCount)
			if throbCount >= maxThrobCount:
				state = "Hatch"
				entering = true
			move_and_slide()
	
	elif state == "Hatch":
		if entering == true:
			$Timer.start()
			if player.sprite.flip_h == false:
				directionCommit = 1
			elif player.sprite.flip_h == true:
				directionCommit = -1
			entering = false
		if not is_on_wall() and not is_on_floor() and not is_on_ceiling():
			self.set_position(Vector2(self.get_position().x +(500 * directionCommit * delta) , self.get_position().y))
		else:
			queue_free()


func _on_area_2d_body_entered(body):
	if state == "Launch":
		state = "Latch"
		entering = true
	elif state == "Hatch":
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


func _on_timer_timeout():
	queue_free()
