extends ColorRect
@onready var play_button = find_child("ResButton")
@onready var quit_button = find_child("QuitButton")
@onready var controls_button = find_child("ControlsButton")
@onready var controls_label = find_child("ControlsLabel")
func resume():
	get_tree().paused = false
	visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	play_button.pressed.connect(resume)
	quit_button.pressed.connect(get_tree().quit)
	controls_button.pressed.connect(controls)

func controls():
	controls_button.visible = false
	controls_label.visible = true
	
func pause():
	get_tree().paused = true
	visible = true
	controls_button.visible = true
	controls_label.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
