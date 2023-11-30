extends Area2D


@export var damage : int = 15
@onready var player = get_parent().get_node("Player")


func _ready():
	monitoring = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.has_method("player"):
		pass
