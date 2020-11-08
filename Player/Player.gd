class_name Player
extends KinematicBody2D

export var minswingspeed := 0.2
export var maxswingspeed := 5
export var speed := 300.0
onready var _sprite := $Sprite
onready var _light := $Light2D
onready var _tween := $Tween
onready var _sword := $Sword
var player_color:String = "red"
var player_number:String = "1"
var VS = false
var _swingspeed := 0.0
var maxhealth := 3.0
var health := 3.0
var _damage := 1
var swingdir := 1
var swinging := false
var _light_colors := {"red":Color.red, "yellow":Color.yellow, "blue":Color(0,0.5,1,1), "green":Color.green}
signal died
signal rejuvenated

func _ready():
	_light.color = _light_colors[player_color]
	_sprite.play(player_color)
	_swingspeed = minswingspeed
	if randi()%2 == 0:
		swingdir = -1
	else:
		swingdir = 1

func _physics_process(delta):
	if health > 0:
		var velocity := Vector2(0,0)
		if Input.is_action_pressed("down_"+player_number):
			velocity.y += 1
		if Input.is_action_pressed("up_"+player_number):
			velocity.y -= 1
		if Input.is_action_pressed("left_"+player_number):
			velocity.x -= 1
		if Input.is_action_pressed("right_"+player_number):
			velocity.x += 1
		if Input.is_action_pressed("Sword_Left_"+player_number):
			swingdir = -1
			swinging = true
		elif Input.is_action_pressed("Sword_Right_"+player_number):
			swingdir = 1
			swinging = true
		if Input.is_action_just_released("Sword_Left_"+player_number) or Input.is_action_just_released("Sword_Right_"+player_number):
			swinging = false
		if swinging:
			if _swingspeed < maxswingspeed:
				_swingspeed += 0.1
		elif not swinging:
			if _swingspeed > minswingspeed:
				_swingspeed -= 0.1
		_sword.rotation_degrees += _swingspeed*swingdir
		var _error = move_and_collide(velocity.normalized()*delta*speed)
		_sprite.rotation_degrees += 1
		_error = $Tween.interpolate_property(_light, "energy", null, health/maxhealth, 0.25)
		_error = $Tween.start()
	if health <= 0:
		_light.enabled = false

func ow(damage):
	if health > 0:
		$AudioStreamPlayer2D.play()
		health -= damage
		if health <= 0:
			emit_signal("died")
			_swingspeed = minswingspeed*swingdir
			$CollisionShape2D.set_deferred("disabled", true)
			var _error = $Tween.interpolate_property(self, "modulate", null, Color(0.5,0.5,0.5,0.5), 0.5)
			_error = $Tween.start()

func _on_Area2D_body_entered(body):
	if body.has_method("hit") and health > 0 and not VS:
		body.hit(_damage)
	elif VS and body.has_method("ow"):
		if body.player_number != player_number:
			body.ow(_damage)

func _heal_area_entered(body):
	if body.has_method("ow") and not VS:
		if health <= 0:
			$Timer.start()

func _on_Timer_timeout():
	health = maxhealth/2
	$Timer.stop()
	_light.enabled = true
	emit_signal("rejuvenated")
	$CollisionShape2D.set_deferred("disabled", false)
	var _error = $Tween.interpolate_property(self, "modulate", null, Color(1,1,1,1), 0.5)
	_error = $Tween.start()
