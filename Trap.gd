extends AnimatedSprite2D

@onready var player = get_parent().get_parent().get_node("Player")
@export var facingRight : bool
var attacking = false
@export var health = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	offset = Vector2(0,0)
	scale = Vector2(1, 1)
	self.flip_h = facingRight
	play("Idle")
#	var hiProfPodder = Vector2(player.get_position())
#	print("Trap says ", hiProfPodder, ", ", player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.is_playing() == false and attacking == false:
		play("Idle")
		offset = Vector2(0,0)
		scale = Vector2(1, 1)
	if animation == "Attack" and frame == 40:
		attacking = false
	if health <= 0:
		queue_free()
	#var player = get_parent().get_node("Player")
	pass
func _on_area_2d_body_entered(body):
	var violator = str(body)
	print("violator is ", violator)
	if violator.begins_with("Player:<CharacterBody2D") == true and attacking == false:
		print("Hey, that's the player! Facing ", player.sprite.flip_h)
		if player.sprite.flip_h == facingRight:
			retract()
		
		
func retract():
	attacking = true
	offset = Vector2(8.715, -133.86)
	play("Retract")
	$Timer.start()

func _on_area_2d_body_exited(body):
	var violateEnder = str(body)
	print(violateEnder, "is exiting.")
	if violateEnder.begins_with("Player:<CharacterBody2D") == true:
		print("Bye, player!")


func _on_timer_timeout():
	print("Ding!")
	scale = Vector2(2,2)
	offset = Vector2(-181.18, -76.95)
	if attacking == true:
		play("Attack")
	


func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	if attacking == false:
		retract()
	health -= 1


func _on_eye_damageable_on_hit(node, damage_taken, knockback_direction):
	attacking = false
	self.stop()
