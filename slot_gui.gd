extends Panel

@onready var player = get_parent().get_parent().get_parent().get_parent().get_parent()
@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var button: Button = $CenterContainer/Panel/item/use
@onready var items : inventoryItem


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
			if player.current_health  < player.max_health:
				player.current_health += 1
				player.healthChanged.emit(player.current_health)
				backgroundSprite.frame = 0
				itemSprite.visible = false
				button.visible = false

