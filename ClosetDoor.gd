extends CharacterBody2D
signal boo
signal closed
var enemyChildren = 0
var unfilteredChildren : int
# Called when the node enters the scene tree for the first time.
func _ready():
	unfilteredChildren = get_children().size()
	for i in unfilteredChildren:
		var childName = str(get_children()[i])
		#print(childName)
		if "closet" not in childName:
			enemyChildren += 1
		else:
			if get_children()[i] is CollisionShape2D:
				get_children()[i].set_deferred("disabled", true)
	hide()
			



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_children().size())
	#print(enemyChildren)
	if unfilteredChildren != get_children().size():
		enemyChildren = 0
		unfilteredChildren = get_children().size()
		for i in unfilteredChildren:
			var childName = str(get_children()[i])
			#print(childName)
			if "closet" not in childName:
				enemyChildren += 1
	if enemyChildren == 0:
		for i in unfilteredChildren:
			var childName = str(get_children()[i])
			#print(str(get_children()[i]), )
			if get_children()[i] is CollisionShape2D:
				#print("Disabled!")
				get_children()[i].set_deferred("disabled", true)
				#print(get_children()[i].disabled)
		hide()
		closed.emit()


func _on_monster_closet_detector_body_exited(body):
	show()
	unfilteredChildren = get_children().size()
	for i in unfilteredChildren:
		var childName = str(get_children()[i])
		if "closet" in childName:
			#print("closet detected!")
			if get_children()[i] is CollisionShape2D:
				#print("closet collision detected!", get_children()[i])
				get_children()[i].set_deferred("disabled", false)
				#print(get_children()[i].disabled)
