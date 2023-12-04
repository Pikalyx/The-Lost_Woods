extends CharacterBody2D

var spawner : PackedScene
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	spawner = ResourceLoader.load("res://Trailer.tscn")

func _physics_process(delta):
	if $SpawnTimer.is_stopped() == true:
		$SpawnTimer.start()


func _on_spawn_timer_timeout():
	var childName = str(get_parent().get_children())
#					print(childName)
	if "Trailer" not in childName:
		var spawn = spawner.instantiate()
		spawn.set_global_position(self.get_global_position())
		get_parent().add_child(spawn)
	
