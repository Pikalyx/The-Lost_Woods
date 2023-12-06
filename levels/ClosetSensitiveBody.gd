extends CharacterBody2D
@export var startOff : bool


var unfilteredChildren : int
# Called when the node enters the scene tree for the first time.
func _ready():
	if startOff == true:
		hide()
	unfilteredChildren = get_children().size()
	for i in unfilteredChildren:
		var childName = str(get_children()[i])
		if "closet" in childName:
			#print("closet detected!")
			if get_children()[i] is CollisionShape2D:
				#print("closet collision detected!", get_children()[i])
				get_children()[i].set_deferred("disabled", startOff)
				#print(get_children()[i].disabled)

func _physics_process(delta):
	pass


func _on_closet_door_3_closed():
	if startOff == true:
		show()
	else:
		hide()
	unfilteredChildren = get_children().size()
	for i in unfilteredChildren:
		var childName = str(get_children()[i])
		if "closet" in childName:
			#print("closet detected!")
			if get_children()[i] is CollisionShape2D:
				#print("closet collision detected!", get_children()[i])
				get_children()[i].set_deferred("disabled", !startOff)
