extends State


class_name AirState

@export var landing_state : State
@export var double_jump_velocity : float = -150
@export var double_jump_animation : String = "double_jump"
@export var landing_animation : String = "landing"
@export var jump_animation : String = "jump_start"
var has_double_jumped = false
var fromWall = false

func state_process(delta):
	if(character.is_on_floor()):
		next_state = landing_state
	if (character.is_on_wall_only()) and character.velocity.y >= 0:
		has_double_jumped = false
		fromWall = true
	if !character.is_on_wall_only() and fromWall == true:
		has_double_jumped = false
		fromWall = false
		playback.travel(jump_animation)
		
func state_input(event : InputEvent):
	if(event.is_action_pressed("jump") && !has_double_jumped):
		double_jump()


func on_exit():
	if(next_state == landing_state):
		playback.travel(landing_animation)
		has_double_jumped = false

func double_jump():
	character.velocity.y = double_jump_velocity
	#var animationPlayer = get_parent().get_parent().get_node("AnimationPlayer")
	playback.travel(double_jump_animation)
	#animated_sprite.play("jump_double")
	if !character.is_on_wall_only():
		has_double_jumped = true
	elif character.is_on_wall_only() and character.velocity.y < 0:
		has_double_jumped = true
