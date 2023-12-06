extends CharacterBody2D

@onready var player = get_parent().get_parent().get_node("Player")
@export var facingRight : bool
var attacking = false
var eating = false
var entering = true
var directionMultiplier = 1
@export var health = 50
@export var damage = 2
@export var inCloset : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	if facingRight:
		directionMultiplier = -1
	$AnimatedSprite2D.offset = Vector2(0,0)
	scale = Vector2(0.15, 0.15)
	$AnimatedSprite2D.play("Idle")
	$AttackingArea2D.monitoring = false
	if inCloset == true:
		hide()
		for i in get_parent().get_children().size():
			var childName = str(get_parent().get_children()[i])
			#print(childName)
			if "monster_closet_detector" in childName:
				var trigger = get_parent().get_children()[i]
				trigger.body_exited.connect(_on_monster_closet_detector_body_exited)
#	var hiProfPodder = Vector2(player.get_position())
#	print("Trap says ", hiProfPodder, ", ", player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(scale)
	if inCloset != true:
		if entering == true:
			if facingRight:
				directionMultiplier = -1
			entering = false
		if $AnimatedSprite2D.is_playing() == false and attacking == false and eating == false:
			$AnimatedSprite2D.play("Idle")
			$AttackingArea2D.monitoring = false
			$AnimatedSprite2D.offset = Vector2(0,0)
			scale = Vector2(0.15 * directionMultiplier, 0.15)
		if $AnimatedSprite2D.animation == "Attack" and $AnimatedSprite2D.frame == 40:
			attacking = false
		if eating == true and $AnimatedSprite2D.frame == 25:
			queue_free()
		#var player = get_parent().get_node("Player")
		pass
		
		
func retract():
	if eating == false:
		attacking = true
		scale = Vector2(0.15 * directionMultiplier, 0.15)
		$AnimatedSprite2D.offset = Vector2(8.715, -133.86)
		$AnimatedSprite2D.play("Retract")
		$Timer.start()
	
func eat():
	scale = Vector2(0.2 * directionMultiplier,0.2)
	$AnimatedSprite2D.offset = Vector2(0,-74.32)
	$AnimatedSprite2D.play("Eat")
	eating = true
	


func _on_timer_timeout():
	print("Ding!")
	if attacking == true and eating == false:
		scale = Vector2(0.35 * directionMultiplier, 0.35)
		$AnimatedSprite2D.offset = Vector2(-181.18, -90)
		$AnimatedSprite2D.play("Attack")
		$AttackingArea2D.monitoring = true
	


func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	if attacking == false:
		retract()


func _on_eye_damageable_on_hit(node, damage_taken, knockback_direction):
	attacking = false
	print("Ow! My eye!")
	$AnimatedSprite2D.stop()


func _on_attacking_area_2d_body_entered(body):
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

func _on_monster_closet_detector_body_exited(body):
	show()
	inCloset = false


func _on_idle_area_2d_body_entered(body):
	if inCloset != true:
		var violator = str(body)
		print("violator is ", violator)
		if violator.begins_with("Player:<CharacterBody2D") == true and attacking == false:
			print("Hey, that's the player! Facing ", body.sprite.flip_h)
			if body.sprite.flip_h == facingRight:
				retract()
		elif violator.begins_with("Trailer") == true and body.state == "Latch":
			print("Hey, that's a trailer!")
			body.queue_free()
			eat()


func _on_idle_area_2d_body_exited(body):
	var violateEnder = str(body)
	print(violateEnder, "is exiting.")
	if violateEnder.begins_with("Player:<CharacterBody2D") == true:
		print("Bye, player!") # Replace with function body.
