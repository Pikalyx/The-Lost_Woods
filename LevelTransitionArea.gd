extends Area2D

@export var targetLevel : String
@export var inCloset : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	if inCloset == true:
		monitoring = false
		hide()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inCloset == false:
		show()
		monitoring = true

func _on_body_entered(body):
	print("changing to ", targetLevel)
	SceneTransition.change_scene_to_file(targetLevel)
	

func _on_closet_door_closed():
	inCloset = false
