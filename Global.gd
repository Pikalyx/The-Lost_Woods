extends Node

class_name Global
var gold = 1000


var items = {
	0: {
		"Name": "Health",
		"Des": "This will give you health!!",
		"Cost": 100,
		"Icon": preload("res://Art/items/Apple.png")
		
	},
	1:  {
		"Name": "speed",
		"Des": "This will increase speed!",
		"Cost": 100,
		"Icon": preload("res://Art/items/Cherries.png")
	},
	2:  {
		"Name": "Extra_Life",
		"Des": "This will give you a extra life!",
		"Cost": 500,
		"Icon": preload("res://Art/items/Pineapple.png")
	},
}
var inventory = {
	0: {
		"Name": "Health",
		"Des": "This will give you health!!",
		"Cost": 100,
		"Icon": preload("res://Art/items/Apple.png"),
		"Count": 1
		
	}
}
