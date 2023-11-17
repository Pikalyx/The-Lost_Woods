extends AnimatedSprite2D

@onready var player = get_parent().get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	play("Idle")
#	var hiProfPodder = Vector2(player.get_position())
#	print("Trap says ", hiProfPodder, ", ", player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.is_playing() == false:
		play("Idle")
	#var player = get_parent().get_node("Player")
	pass
func _on_area_2d_body_entered(body):
	var violator = str(body)
	print("violator is ", violator)
	if violator.begins_with("Player:<CharacterBody2D") == true:
		print("Hey, that's the player! Facing ", player.sprite.flip_h)
		
		


func _on_area_2d_body_exited(body):
	var violateEnder = str(body)
	print(violateEnder, "is exiting.")
	if violateEnder.begins_with("Player:<CharacterBody2D") == true:
		print("Bye, player!")
