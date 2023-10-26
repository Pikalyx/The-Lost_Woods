extends GridContainer

@onready var item = preload("res://slot.tscn")
var invSize = 6

func _ready():
	for i in invSize:
		var itemTemp = item.instantiate()
		add_child(itemTemp)
		
		fillInventorySlots()
		

func fillInventorySlots():
	for i in global.inventory:
		get_child(i).ItemName = global.inventory[i]["Name"]
		get_child(i).ItemDes = global.inventory[i]["Des"]
		get_child(i).ItemCost = global.inventory[i]["Cost"]
		get_child(i).ItemCount = global.inventory[i]["Count"]
		get_child(i).get_node("Icon").texture = (global.inventory[i]["Icon"])
		get_child(i).hasItem = true
		
		
		
