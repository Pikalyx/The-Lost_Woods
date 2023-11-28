extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$CollisionShape2D.disabled = true # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_monster_closet_detector_body_exited(body):
	show()
	$CollisionShape2D.disabled = false
	print($CollisionShape2D.disabled)
