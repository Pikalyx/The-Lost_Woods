extends Node

class_name hitMain

@export var damageable : Damageable
@export var dead_state : State
@export var dead_animation_node : String = "dead"
@export var knockback_speed : float = 100.0

@onready var timer : Timer = $Timer
func _ready():
	damageabdle.connect("on_hit", on_damageable_hist)
	
func on_enter():
	timer.start()

func on_damageable_hit(node : Node , damage_amount : int, knockback_direction : Vector2):
	if(damageable.health > 0):
		character.velocity = knockback_speed * knockback_direction
		emit_signal("interrupt_state", self)
	else:
		emit_signal("interrupt_state",dead_state)
		playback.travel(dead_animation_node)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
