extends Node2D

var _chosen_colors := []
var _player1_color:String = ""
var _player2_color:String = ""
var _player3_color:String = ""
var _player4_color:String = ""
signal color_chosen(color, id)
signal color_taken_back(color)

func _process(_delta):
	if _player1_color != "" and _player2_color != "":
		if Input.is_action_just_pressed("start_game"):
			print("Game Started")

func _on_PlayerInitiator_chosen_color(color, id):
	_set_player_color(color, id)
	emit_signal("color_chosen", color, id)

func _set_player_color(set_to, id):
	if id == "1":
		_player1_color = set_to
	elif id == "2":
		_player2_color = set_to
	elif id == "3":
		_player3_color = set_to
	elif id == "4":
		_player4_color = set_to

func _on_PlayerInitiator_color_taken_back(color, id):
	_set_player_color("", id)
	emit_signal("color_taken_back", color)
