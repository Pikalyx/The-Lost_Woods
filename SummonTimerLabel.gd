extends RichTextLabel

@onready var summonTimer = get_parent().get_node("ClosetDoor/Boss/SummonTimer")
# Called when the node enters the scene tree for the first time.
func _ready():
	hide() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if summonTimer != null:
		if summonTimer.is_stopped() == false:
			show()
			var display = "{0}".format("%0.2f" % str(summonTimer.get_time_left()))
			text = str(summonTimer.get_time_left())
			print(text)
		else:
			hide()
