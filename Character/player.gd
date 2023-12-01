extends CharacterBody2D

class_name Player

@export var normalspeed  = 200.0
@export var speed : float = 200.0
@export var max_health : float = PlayerVars.h
@export var score : float = PlayerVars.s
@export var current_health : float = PlayerVars.ch
signal healthChanged(cur)
var clingSlide = false
var colorAdjust = 0
@onready var defaultModulate = $Sprite2D.modulate
@onready var dash = $Dash
@export var dashspeed = 1200.0
@export var dashlength = .1
@export var dead_state : State
@export var dead_animation_node : String = "dead"

@onready var heartsContainer = $CanvasLayer3/hearts_container
#@onready var dash = $Dash
#@onready var cooldown = $Cooldown

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction : Vector2 = Vector2.ZERO

signal facing_direction_changed(facing_right : bool)

func setMaxHealth(max: int):
	max_health = max
	
func _ready():
	animation_tree.active = true
	heartsContainer.setMaxHearts(max_health)
	heartsContainer.updateHearts(current_health)
	healthChanged.connect(heartsContainer.updateHearts)

func _physics_process(delta):
	# Add the gravity.
	if current_health > 0:
		if is_on_wall_only() and velocity.y >= 0 and clingSlide == false:
			velocity.y = 0
			if $ClingTimer.is_stopped():
				$ClingTimer.start()
		elif is_on_wall_only() and velocity.y >= 0 and clingSlide == true:
			velocity.y += (gravity/5) * delta
		elif not is_on_floor():
			velocity.y += gravity * delta
		#print("Am I on a wall? That's ", self.is_on_wall())
		if Input.is_action_just_pressed("dash"):
			if dash.is_on_cooldown():
				dash.start_dash(dashlength)
	#	if dash._on_dashtimer_timeout():
	#		cooldown.start_cooldown(1)
		var speed = dashspeed if dash.is_dashing() else normalspeed
		if $RecoilTimer.is_stopped() == false:
			colorAdjust += 0.1
			$Sprite2D.modulate = Color(colorAdjust,0,0)
			if colorAdjust >= 5:
				colorAdjust = 0
		else:
			$Sprite2D.modulate = defaultModulate
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_vector("left", "right", "up", "down")
		
		if direction.x != 0 && state_machine.check_if_can_move():
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor():
			clingSlide = false
			$ClingTimer.stop()
		move_and_slide()
		update_animation_parameters()
		update_facing_direction()
	else:
		$Sprite2D.modulate = defaultModulate
		#SceneTransition.change_scene_to_file("res://Game_Over.tscn")
		#$AnimationPlayer.play("dead")
#		if notDead:
#			$AnimationPlayer.play("dead")
#			notDead = false
#		if $AnimationPlayer.current_animation_position == $AnimationPlayer.current_animation_length:
#			queue_free()
	
func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position",direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	
	elif direction.x < 0:
		sprite.flip_h = true
		
	emit_signal("facing_direction_changed", !sprite.flip_h)

@export var inventory: Inventory

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		$CanvasLayer3/PauseMenu.pause()
	$CanvasLayer3/Score.updateScore(score)
	PlayerVars.setCH(current_health)
	PlayerVars.setS(score)
	PlayerVars.setT($CanvasLayer3/Timer.time)
		
func _on_area_2d_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
	if area.has_method("heal") && current_health < max_health:
		current_health += 1
		healthChanged.emit(current_health)
	if area.has_method("heal"):
		score += 10
		#print(self, "just collided with ", area )


func _on_inventory_gui_closed():
	pass # Replace with function body.


func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	if $RecoilTimer.is_stopped() == true:
		current_health -= damage_taken
		healthChanged.emit(current_health)
		$RecoilTimer.start()
		score -= 1


func _on_cling_timer_timeout():
	clingSlide = true
	print("Slidin!") # Replace with function body.
