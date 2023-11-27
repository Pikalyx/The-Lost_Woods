extends ColorRect
@onready var play_button = find_child("ResButton")
@onready var quit_button = find_child("QuitButton")

func resume():
	get_tree().paused = false
	visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	play_button.pressed.connect(resume)
	quit_button.pressed.connect(get_tree().quit)

func pause():
	get_tree().paused = true
	visible = true
