extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree

@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var movement_speed : float = 30.0 * PlayerVars.esm
@export var hit_state : State
@export var inCloset : bool
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@export var dead_animation_name : String = "dead"
@export var damage = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	animation_tree.active = true
	if starting_move_direction.x > 0:
		scale.x = -scale.x
	if inCloset == true:
		hide()
		for i in get_parent().get_children().size():
			var childName = str(get_parent().get_children()[i])
			#print(childName)
			if "monster_closet_detector" in childName:
				var trigger = get_parent().get_children()[i]
				trigger.body_exited.connect(_on_monster_closet_detector_body_exited)


func _physics_process(delta):
	# Add the gravity.
	if inCloset != true:
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


func _on_monster_closet_detector_body_exited(body):
	show()
	inCloset = false # Replace with function body.



func _on_area_2d_body_entered(body):
	if $Damageable.health > 0:
		for child in body.get_children():
			if child is Damageable:
				print(self, " is hitting ", child)
				var direction_to_damageable = (body.global_position - get_parent().global_position) 
				var direction_sign = sign(direction_to_damageable.x)
				
				if(direction_sign > 0):
					child.hit(damage, Vector2.RIGHT)
				elif(direction_sign < 0):
					child.hit(damage, Vector2.LEFT)
				else:
					child.hit(damage, Vector2.ZERO) # Replace with function body.
