extends KinematicBody2D

export var speed := 200.0
onready var _sprite := $Sprite
onready var _light := $Light2D
onready var _tween := $Tween
var player_color:String = "red"
var player_number:String = "1"
var _light_colors := {"red":Color.red, "yellow":Color.yellow, "blue":Color.blue, "green":Color.green}

func _ready():
	_light.color = _light_colors[player_color]
	_sprite.play(player_color)

func _physics_process(delta):
	var velocity := Vector2(0,0)
	if Input.is_action_pressed("down_"+player_number):
		velocity.y += 1
	if Input.is_action_pressed("up_"+player_number):
		velocity.y -= 1
	if Input.is_action_pressed("left_"+player_number):
		velocity.x -= 1
	if Input.is_action_pressed("right_"+player_number):
		velocity.x += 1
	var _error = move_and_collide(velocity*speed*delta)
	_sprite.rotation_degrees += 1
