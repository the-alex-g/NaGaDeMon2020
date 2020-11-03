extends Node2D

const player := preload("res://Player/Player.tscn")
const selector := preload("res://Main/PlayerInitiator.tscn")
onready var _main_menu := $MainMenu
onready var _players := $Gameplay/Players
onready var _selectors := $MainMenu/PlayerPickers
var _player_count := 0
var _player1_color:String = "not"
var _player2_color:String = "not"
var _player3_color:String = "not"
var _player4_color:String = "not"
signal color_chosen(color, id)
signal color_taken_back(color)
signal game_started

func _process(_delta):
	if _player1_color != "" and _player2_color != "" and _player_count > 0:
		if Input.is_action_just_pressed("start_game"):
			_main_menu.hide()
			emit_signal("game_started")
			for x in 2:
				var Player := player.instance()
				Player.player_number = x+1
				Player.player_color = get("_player"+str(x+1)+"_color")
				_players.add_child(Player)
				print("SPAWNED ONE")
	if Input.is_action_just_pressed("select_1") and _player1_color == "not":
		_add_player_selector(1)
		_player_count += 1
		_player1_color = ""
	if Input.is_action_just_pressed("select_2") and _player2_color == "not":
		_add_player_selector(2)
		_player_count += 1
		_player2_color = ""
	if Input.is_action_just_pressed("select_3") and _player3_color == "not":
		_add_player_selector(3)
		_player_count += 1
		_player3_color = ""
	if Input.is_action_just_pressed("select_4") and _player4_color == "not":
		_add_player_selector(4)
		_player_count += 1
		_player4_color = ""

func _add_player_selector(id):
	var Selector := selector.instance()
	Selector.player_id = id
	Selector.player_color_choice = Selector.player_colors[id-1]
	var _error = Selector.connect("chosen_color", self, "_chosen_color")
	var _error2 = Selector.connect("color_taken_back", self, "_color_taken_back")
	var _error4 = connect("color_taken_back", Selector, "_color_taken_back")
	var _error3 = connect("color_chosen", Selector, "_color_chosen")
	Selector.position = Vector2(id*100, 300)
	_selectors.add_child(Selector)

func _chosen_color(color, id):
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

func _color_taken_back(color, id):
	_set_player_color("", id)
	emit_signal("color_taken_back", color)
