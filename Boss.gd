extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
@onready var animation = $AnimationPlayer
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
signal zoomOut
var state = "Waiting"
@export var inCloset : bool
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Sprite2D.flip_h = true
	if inCloset == true:
		hide()
		$BodyCollisionShape2D.disabled = true
		var trigger = get_parent().get_node("monster_closet_detector")
		trigger.body_exited.connect(_on_monster_closet_detector_body_exited)
		if player == null:
			var playerSeek = get_parent().get_parent().get_node("Player")
			if playerSeek != null:
				player = playerSeek
			else:
				player = get_parent().get_parent().get_parent().get_node("Player")
				
func _physics_process(delta):
	if inCloset != true:
		if state == "Waiting":
			if animation.is_playing() == false:
				animation.play("idle")
				print(animation.current_animation)
		elif state == "Walking":
			if animation.is_playing() == false:
				animation.play("walk")
			velocity.x = SPEED * delta

		if not is_on_floor():
			velocity.y += gravity * delta
		
	# Handle Jump

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	move_and_slide()


func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	if state == "Waiting":
		zoomOut.emit() # Replace with function body.
		state = "Walking"
	
func _on_monster_closet_detector_body_exited(body):
	show()
	inCloset = false
	$BodyCollisionShape2D.set_deferred("disabled", false)
