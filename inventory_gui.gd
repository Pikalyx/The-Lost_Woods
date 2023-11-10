extends Control



var isOpen: bool = false


@onready var inventory: Inventory = preload("res://Inventory/PlayerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	update()

func update():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func open():
	visible = true
	isOpen = true

func close():
	visible = false
	isOpen = false
