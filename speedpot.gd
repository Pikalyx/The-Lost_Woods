extends "res://Collectable.gd"

@onready var animation = $AnimationPlayer


func collect():
	animation.play("spin")
	await animation.animation_finished
	super.collect()
