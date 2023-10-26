extends CanvasLayer

@export var global : Global
var curItem = 0
var select = 0

func _on_close_pressed():
	get_node("Anim").play("TransOut")
	get_tree().paused = false     

func switchItems(select):
	for i in range(global.items.size()):
		if select == i:
			curItem = select
			get_node("Control/Item").texture = global.items[curItem]["Icon"]
			get_node("Control/Name").text = global.items[curItem]["Name"]
			get_node("Control/Des").text = global.items[curItem]["Des"]
			get_node("Control/Des").text +="\nCost: " + str(global.items[curItem]["Cost"])

func _on_next_pressed():
	switchItems(curItem+1)


func _on_prev_pressed():
	switchItems(curItem-1)


func _on_buy_pressed():
	var hasItem = false
	if global.gold > global.items[curItem]["Cost"]:
		for i in global.inventory:
			if global.inventory[i]["Name"] == global.items[curItem]["Name"]:
				global.inventory[i]["Count"] += 1
				hasItem = true
		if hasItem == false:
			var tempDic = global.items[curItem]
			tempDic["Count"] = 1
			global.inventory[global.inventory.size()] = tempDic
		global.gold -= global.items[curItem]["Cost"]
	print(global.items[curItem])
