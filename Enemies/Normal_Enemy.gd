extends KinematicBody2D

export var speed := 200
export var minswingspeed := 0.2
export var maxswingspeed := 5
onready var _sight := $Sightrange
onready var _sprite := $Sprite
onready var _sword := $Sword
var _target
var swingdir := 1
var swinging := false
var _swingspeed := 0.0
var health := 1
var _damage := 1
var should_move := false
signal died

func _ready():
	_new_sword_dir()

func _process(delta):
	_sprite.rotation_degrees -= 1
	if should_move:
		var destination:Vector2
		if _target != null:
			destination = _target.get_global_transform().origin
		var direction = destination - get_global_transform().origin
		var velocity = direction.normalized() * speed
		var _error = move_and_collide(velocity*delta)
		for body in _sight.get_overlapping_bodies():
			if body is Player:
				if body.health > 0:
					if abs((body.get_global_transform().origin - get_global_transform().origin).length_squared()) < abs((_target.get_global_transform().origin-get_global_transform().origin).length_squared()) or _target == null:
						_target = body
		if _target.health <= 0:
			_target = null
			should_move = false
			for body in _sight.get_overlapping_bodies():
				if body is Player:
					if body.health != 0:
						_target = body
						should_move = true
						break
	if swinging:
		if _swingspeed < maxswingspeed:
			_swingspeed += 0.1
	elif not swinging:
		if _swingspeed > minswingspeed:
			_swingspeed -= 0.1
	_sword.rotation_degrees += _swingspeed*swingdir

func hit(damage):
	health -= damage
	if health <= 0:
		emit_signal("died")
		queue_free()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.ow(_damage)

func _new_sword_dir():
	var swordswingdir := randi()%3
	if swordswingdir == 0:
		swinging = true
		swingdir = -1
	elif swordswingdir == 1:
		swinging = false
	elif swordswingdir == 2:
		swinging = true
		swingdir = 1

func _on_Timer_timeout():
	_new_sword_dir()

func _on_Sightrange_body_entered(body):
	if body is Player:
		should_move = true
		_target = body
