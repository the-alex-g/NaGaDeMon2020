extends Node2D

onready var _sprite := $Sprite
export var player_id := "1"
var player_colors := ["red", "yellow", "blue","green"]
var _player_color_choice_id := 0
export var _player_color_choice := "red"
var _done := false
signal chosen_color(color, id)
signal color_taken_back(color, id)

func _process(_delta):
	if not _done:
		if Input.is_action_just_pressed("right_"+player_id):
			_player_color_choice_id += 1
			_player_color_choice = player_colors[_player_color_choice_id%(player_colors.size())]
		if Input.is_action_just_pressed("left_"+player_id):
			_player_color_choice_id -= 1
			_player_color_choice = player_colors[_player_color_choice_id%(player_colors.size())]
		if Input.is_action_just_pressed("select_"+player_id):
			emit_signal("chosen_color", _player_color_choice, player_id)
			_done = true
	if Input.is_action_just_pressed("deselect_"+player_id):
		_done = false
		emit_signal("color_taken_back", _player_color_choice, player_id)
	_sprite.play(_player_color_choice)

func _on_Main_color_chosen(color):
	for acolor in player_colors.size():
		if player_colors[acolor] == color:
			player_colors.remove(acolor)
			break

func _on_Main_color_taken_back(color):
	player_colors.append(color)
