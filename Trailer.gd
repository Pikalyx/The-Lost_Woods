extends Sprite2D

var stalkOffset : float
var windUp = true
var directionCommit : float
@onready var player = get_parent().get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if windUp == true:
		#var player = get_parent().get_node("Player")
		if player.direction.x == 1:
			stalkOffset = (player.get_position().x - 50)
		elif player.direction.x == -1:
			stalkOffset = (player.get_position().x + 50)
		self.set_position(Vector2(stalkOffset, player.get_position().y))
	elif windUp == false:
			self.set_position(Vector2(self.get_position().x +(500 * directionCommit * delta) , self.get_position().y))


func _on_audio_stream_player_2d_finished():
	windUp = false
	var player = get_parent().get_node("Player")
	if player.sprite.flip_h == false:
		directionCommit = 1
	elif player.sprite.flip_h == true:
		directionCommit = -1
