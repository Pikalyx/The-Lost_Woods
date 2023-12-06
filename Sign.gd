extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea


@export var lines: Array[String] = [
	"Hello 234",
	"Hi",
	"Howdey",
	"Haloha",
	"Goodbye"
]

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact():
	DialogManager.start_dialog(global_position, lines)
	#await DialogManager.dialog_finished
