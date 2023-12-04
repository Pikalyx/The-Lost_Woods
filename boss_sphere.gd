extends Area2D

signal collected
@export var origin = Vector2(825, -180)
# Called when the node enters the scene tree for the first time.
func _ready():
	self.global_position = origin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	collected.emit()
	queue_free()
