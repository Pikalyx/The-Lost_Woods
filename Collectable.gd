extends Area2D

@export var itemRes: inventoryItem 


func collect(inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()

func heal():
	pass

