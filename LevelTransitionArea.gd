extends Area2D

@export var targetLevel : String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	print("changing to ", targetLevel)
	SceneTransition.change_scene_to_file(targetLevel)
