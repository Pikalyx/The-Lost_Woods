extends Node2D

@onready var heartsContainer = $CanvasLayer2/hearts_container
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	heartsContainer.setMaxHearts(player.max_health)
	heartsContainer.updateHearts(player.current_health)
	player.healthChanged.connect(heartsContainer.updateHearts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
