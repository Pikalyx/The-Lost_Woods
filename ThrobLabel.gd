extends RichTextLabel
@onready var trailer = get_parent()
@onready var display : int
# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = Color(1,0,0)
	push_outline_color(Color(0,0,0))
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trailer.state == "Latch":
		show()
		display = trailer.throbCount
		text = str(trailer.maxThrobCount - display)
	else:
		hide()
	
