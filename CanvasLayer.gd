extends CanvasLayer


func _ready():
	inventory.close()

@onready var inventory = $InventoryGUI
func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
	
