extends Node

@onready var text_box_scene = preload("res://Art/Dia-Box/text-box.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_postion: Vector2

var is_dialog_active = false
var van_advance_line = false

func start_dialog(position: Vector2, lines: Array[String]):
	if is_dialog_active:
		return
		
	dialog_lines = lines
	text_box_position = position
	_show_text_box()
	
	is_dialog_active = true
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = flase
