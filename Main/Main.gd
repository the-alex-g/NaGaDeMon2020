extends Node2D

var _chosen_colors := []
var _player1_color:String = "red"
var _player2_color:String = "red"
var _player3_color:String = "red"
var _player4_color:String = "red"
signal nope(id)

func _on_PlayerInitiator_chosen_color(color, id):
	for chosen_color in _chosen_colors.size():
		if color == _chosen_colors[chosen_color]:
			if get("_player"+id+"_color") != color:
				emit_signal("nope", id)
			else:
				_chosen_colors.remove(chosen_color)
				_chosen_colors.append(color)
				break
		else:
			_chosen_colors.append(color)
			break
