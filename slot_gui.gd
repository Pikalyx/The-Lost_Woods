extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var button: Button = $CenterContainer/Panel/use


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
		
		
		
func health_me(item: inventoryItem):
	if item.name ==  "HealthFlute":
		return true

			
		
			
			
		
		
	
