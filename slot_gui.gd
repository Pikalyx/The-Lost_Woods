extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var button: Button = $CenterContainer/Panel/item/use
@onready var items : inventoryItem
@onready var player = get_parent().get_node("Player")


func update(item: inventoryItem):
	if !item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
		button.visible = false
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		button.visible = true
		itemSprite.texture = item.texture
		items = item
		
func _on_use_pressed():
	if backgroundSprite.frame == 1:
		if items.name == "HealthFlute":
			#print(players.current_health)
			pass
