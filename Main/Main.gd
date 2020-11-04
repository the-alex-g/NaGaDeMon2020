extends Node2D

const player := preload("res://Player/Player.tscn")
const selector := preload("res://Main/PlayerInitiator.tscn")
onready var _main_menu := $MainMenu
onready var _players := $Gameplay/Players
onready var _selectors := $MainMenu/PlayerPickers
onready var _playerpositions := $Gameplay/Positions/Playerpositions
onready var _camerapositions := $Gameplay/Positions/Camerapostions
onready var _camera := $Camera2D
var _player_count := 0
var _player1_color:String = "not"
var _player2_color:String = "not"
var _player3_color:String = "not"
var _player4_color:String = "not"
var _level := 0
var L1_exit_limit := 1
var L2_exit_limit := 2
var L3_exit_limit := 1
var L4_exit_limit := 1
var L5_exit_limit := 1
var L6_exit_limit := 1
var L7_exit_limit := 1
var L8_exit_limit := 1
signal color_chosen(color, id)
signal color_taken_back(color)
signal game_started

func _ready():
	_camera.position = _camerapositions.get_node("Position1").get_global_transform().origin

func _process(_delta):
	if _player1_color != "" and _player2_color != "" and _player_count > 0:
		if Input.is_action_just_pressed("start_game"):
			_main_menu.hide()
			emit_signal("game_started")
			for x in _player_count:
				var _Player := player.instance()
				_Player.player_number = x+1
				_Player.player_color = get("_player"+str(x+1)+"_color")
				_Player.position = _playerpositions.get_node("Position1_"+str(x+1)).get_global_transform().origin
				_players.add_child(_Player)
			_camera.position = _camerapositions.get_node("Position2").get_global_transform().origin
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

func _create_enemy(enemy):
	$Gameplay/Enemies.add_child(enemy)

func _L1_spawner_cleared():
	L1_exit_limit -= 1

func _on_Portal_entered(destination, location):
	if get("L"+str(location)+"_exit_limit") == 0:
		go_to_next_level(destination)

func go_to_next_level(level):
	_level = level
	for player in _players.get_children():
		player.position = _playerpositions.get_node("Position"+str(_level)+"_"+player.player_number).get_global_transform().origin
		player.health = player.maxhealth
	_camera.position = _camerapositions.get_node("Position"+str(_level+1)).get_global_transform().origin

func _L2_spawner_cleared():
	L2_exit_limit -= 1
