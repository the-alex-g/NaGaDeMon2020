class_name Player
extends KinematicBody2D

export var minswingspeed := 0
export var maxswingspeed := 0.2
export var speed := 300.0
onready var _sprite := $Sprite
onready var _light := $Light2D
onready var _tween := $Tween
onready var sword:Node2D = $Weapon
var player_color:String = "red"
var player_number:String = "1"
var VS = false
var _swingspeed := 0.0
var maxhealth := 3.0
var health := 3.0
var ram := false
var swingdir := 1
var acceleration_increment := 0.01
var swinging := false
var _light_colors := {"red":Color.red, "yellow":Color.yellow, "blue":Color(0,0.5,1,1), "green":Color.green}
signal died
signal rejuvenated
signal dropped_weapon(drop)

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
		if Input.is_joy_button_pressed(int(player_number)-1, 0) and ram:
			var _error = move_and_collide((Vector2(1,1).normalized()*200).rotated(deg2rad(sword.rotation_degrees-135)))
			ram = false
			yield(get_tree().create_timer(1), "timeout")
			ram = true
		if Input.is_joy_button_pressed(int(player_number)-1, 2):
			new_weapon("Sword", true)
		var sword_data := Vector2(Input.get_joy_axis(int(player_number)-1, JOY_ANALOG_RX), Input.get_joy_axis(int(player_number)-1, JOY_ANALOG_RY))
		var sword_dir := rad2deg(sword_data.angle())+90
		var target_rotation = sword_data.angle() + PI/2
		var new_angle = _lerp_angle(sword.rotation, target_rotation, _swingspeed)
		
		sword.rotation = new_angle
		
		
		if round(sword_dir) == 0:
			if _swingspeed > minswingspeed:
				_swingspeed -= acceleration_increment
			swingdir = 0
		else:
			if _swingspeed < maxswingspeed:
				_swingspeed += acceleration_increment
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

func new_weapon(type:String, dropped:bool = false):
	if type == "Ram":
		speed = 100
		ram = true
	elif type == "Hammer":
		speed = 200
		health += 3
		maxhealth = 6
	elif type != "Hammer" and sword.type == "Hammer":
		speed = 300
		if health > 3:
			health = 3
		elif health < 3:
			health = 1
		maxhealth = 3
	elif type != "Ram" and sword.type == "Ram":
		speed = 300
		ram = false
	if sword.type != "Sword" and dropped:
		var drope = load("res://Enemies/Drop.tscn").instance()
		drope.type = sword.type
		drope.position = Vector2(self.get_global_transform().origin.x+50, self.get_global_transform().origin.y)
		emit_signal("dropped_weapon", drope)
	sword.switch_type(type)

# Adapted from https://godotengine.org/qa/41043/lerping-angle-while-going-trought-shortest-possible-distance
func _lerp_angle(from:float, to:float, weight:float)->float:
	return from + _short_angle_dist(from, to) * weight
#
func _short_angle_dist(from:float, to:float)->float:
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
