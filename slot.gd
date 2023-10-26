extends Panel


var ItemName = ""
var ItemDes = ""
var ItemCost = 0
var ItemCount = 0
var hasItem = false 
var mouseEntered = false

func _ready():
	pass
	
func _process(delta):
	if hasItem ==  true: 
		get_node("Icon").show()
	else:
		get_node("Icon").hide()
