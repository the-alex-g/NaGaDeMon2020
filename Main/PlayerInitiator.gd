extends Node2D

onready var _sprite := $Sprite
onready var _button := $Button
export var player_id := "1"
var player_colors := ["red", "yellow", "blue","green"]
var player_color_choice_id := 0
export var player_color_choice := "red"
var _done := false
var _add_to_anim := ""
signal chosen_color(color, id)
signal color_taken_back(color, id)

func _process(_delta):
	if not _done:
		if Input.is_action_just_pressed("right_"+player_id):
			player_color_choice_id += 1
			player_color_choice = player_colors[player_color_choice_id%(player_colors.size())]
		if Input.is_action_just_pressed("left_"+player_id):
			player_color_choice_id -= 1
			player_color_choice = player_colors[player_color_choice_id%(player_colors.size())]
		if Input.is_action_just_pressed("select_"+player_id):
			emit_signal("chosen_color", player_color_choice, player_id)
			_done = true
			_add_to_anim = "_go"
		_button.type = "A2"
		$Label2.text = "Select"
	elif _done:
		_button.type = "B3"
		$Label2.text = "Back"
	if Input.is_action_just_pressed("deselect_"+player_id):
		_done = false
		_add_to_anim = ""
		emit_signal("color_taken_back", player_color_choice, player_id)
	_sprite.play(player_color_choice+_add_to_anim)

func _color_chosen(color, id):
	if color == player_color_choice and player_id != id:
		player_color_choice_id += 1
		player_color_choice = player_colors[player_color_choice_id%(player_colors.size())]
	for acolor in player_colors.size():
		if player_colors[acolor] == color:
			player_colors.remove(acolor)
			break

func _color_taken_back(color):
	player_colors.append(color)
