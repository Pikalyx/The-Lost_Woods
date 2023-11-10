extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed : float = 200.0

@export var max_health : float = 4.0
var current_health: int = max_health

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction : Vector2 = Vector2.ZERO

signal facing_direction_changed(facing_right : bool)



func _ready():
	animation_tree.active = true
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		$PauseMenu.pause()

	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x != 0 && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation_parameters()
	update_facing_direction()
	
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)

func _on_hurt_box_area_entered(area):
	if area.name == "hitbox":
		current_health -=1
		if current_health < 0:
			current_health = max_health
		healthChanged.emit(current_health)
		print("hit")
		
func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position",direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	
	elif direction.x < 0:
		sprite.flip_h = true
		
	emit_signal("facing_direction_changed", !sprite.flip_h)

