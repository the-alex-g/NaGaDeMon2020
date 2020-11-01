extends Node2D

onready var _sprite := $Sprite
export var player_id := "1"
var player_colors := ["red", "yellow", "blue","green"]
var _player_color_choice_id := 0
var _player_color_choice := "red"
signal chosen_color(color, id)
signal player_ready(color, id)

func _ready():
	emit_signal("chosen_color", _player_color_choice, player_id)

func _process(_delta):
	if Input.is_action_just_pressed("right_"+player_id):
		_player_color_choice_id += 1
		_player_color_choice = player_colors[_player_color_choice_id%4]
		_sprite.play(_player_color_choice)
		emit_signal("chosen_color", _player_color_choice, player_id)
	if Input.is_action_just_pressed("left_"+player_id):
		_player_color_choice_id -= 1
		_player_color_choice = player_colors[_player_color_choice_id%4]
		_sprite.play(_player_color_choice)
		emit_signal("chosen_color", _player_color_choice, player_id)
	if Input.is_action_just_pressed("select_"+player_id):
		emit_signal("player_ready", _player_color_choice, player_id)

func _on_Main_nope(id):
	if id == player_id:
		_player_color_choice_id += 1
		_player_color_choice = player_colors[_player_color_choice_id%4]
		_sprite.play(_player_color_choice)
		emit_signal("chosen_color", _player_color_choice, player_id)
