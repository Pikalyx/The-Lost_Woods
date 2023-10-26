extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#for the enemy, follow this
func _on_button_pressed():
	get_node("Anim").play("TransOut")
	
func _input(event):
	if event.is_action_pressed("Inv"):
		if self.offset.y == 900:
			get_node("Anim").play("TransIn")
		elif self.offset.y == -900:
			get_node("Anim").play("TransIn")
		elif self.offset.y == 0:
			get_node("Anim").play("TransOut")
		
