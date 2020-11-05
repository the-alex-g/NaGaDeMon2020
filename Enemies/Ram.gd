extends KinematicBody2D

export var speed := 200
export var minswingspeed := 0.2
export var maxswingspeed := 5
onready var _sight := $Sightrange
onready var _sprite := $Sprite
var _target
var health := 1
var _damage := 2
var should_move := false
var destination:Vector2
var direction:Vector2
signal died

func _ready():
	$Timer.start()
	$Timer2.start()

func _process(delta):
	_sprite.rotation_degrees += 1
	if should_move:
		if _target != null:
			destination = _target.get_global_transform().origin
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
	$Ram.rotation_degrees = rad2deg(direction.angle())+90

func hit(damage):
	health -= damage
	if health <= 0:
		emit_signal("died")
		queue_free()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.ow(_damage)

func _on_Timer_timeout():
		var velocity = direction.normalized() * speed
		var _error = move_and_collide(velocity)
		$Timer2.start()

func _on_Sightrange_body_entered(body):
	if body is Player:
		should_move = true
		_target = body

func _on_Timer2_timeout():
	direction = destination - get_global_transform().origin
