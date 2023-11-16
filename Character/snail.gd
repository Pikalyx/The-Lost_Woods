extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree

@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var movement_speed : float = 30.0
@export var hit_state : State
@export var inCloset : bool

@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	animation_tree.active = true
	if inCloset == true:
		hide()


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and visible == true:
		velocity.y += gravity * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : Vector2 = starting_move_direction
	if direction && state_machine.check_if_can_move() and visible == true:
		velocity.x = direction.x * movement_speed
	elif state_machine.current_state != hit_state and visible == true:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	else:
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()


func _on_monster_closet_detector_body_entered(body):
	show()
	print("Boo!") # Replace with function body.
