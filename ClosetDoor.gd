extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	hide() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_monster_closet_detector_body_exited(body):
	show() # Replace with function body.
