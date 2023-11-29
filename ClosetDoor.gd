extends CharacterBody2D
signal boo
var enemyChildren = 0
var unfilteredChildren : int
# Called when the node enters the scene tree for the first time.
func _ready():
	unfilteredChildren = get_children().size()
	for i in unfilteredChildren:
		var childName = str(get_children()[i])
		print(childName)
		if "closet" not in childName:
			enemyChildren += 1
	hide()
	$closet_collision.disabled = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_children().size())
	if unfilteredChildren != get_children().size():
		enemyChildren = 0
		unfilteredChildren = get_children().size()
		for i in unfilteredChildren:
			var childName = str(get_children()[i])
			#print(childName)
			if "closet" not in childName:
				enemyChildren += 1
		print(enemyChildren)
	if enemyChildren == 0:
		$closet_collision.set_deferred("disabled", true)
		hide()


func _on_monster_closet_detector_body_exited(body):
	show()
	$closet_collision.set_deferred("disabled", false)
	print($closet_collision.disabled)
