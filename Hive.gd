extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
var spawner : PackedScene
var cooldown = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var fuckRadius = 200
# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	spawner = ResourceLoader.load("res://Trailer.tscn")

func _physics_process(delta):
	if player != null:
		if ((player.get_position().x - self.get_global_position().x) <= fuckRadius and (player.get_position().x - self.get_global_position().x) >= -fuckRadius) and ((player.get_position().y - self.get_global_position().y) <= fuckRadius and (player.get_position().y - self.get_global_position().y) >= -fuckRadius):
			#print($SpawnTimer.time_left)
			if cooldown == false:
				cooldown = true
				$SpawnTimer.start()
				var childName = str(get_parent().get_children())
#					print(childName)
				if "Trailer" not in childName:
					$AnimationPlayer.play("Spurt")
					var spawn = spawner.instantiate()
					spawn.set_global_position(self.get_global_position()) # + Vector2(0,25)
					get_parent().add_child(spawn)
		else:
			if $SpawnTimer.is_stopped() == false:
				cooldown = false
				$SpawnTimer.stop()


func _on_spawn_timer_timeout():
	cooldown = false
#	var childName = str(get_parent().get_children())
##					print(childName)
#	if "Trailer" not in childName:
#		var spawn = spawner.instantiate()
#		spawn.set_global_position(self.get_global_position()) # + Vector2(0,25)
#		get_parent().add_child(spawn)
	pass
