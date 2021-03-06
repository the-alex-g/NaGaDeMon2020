extends KinematicBody2D

export var speed := 200
export var minswingspeed := 0.2
export var maxswingspeed := 5
onready var _sight := $Sightrange
onready var _sprite := $Sprite
var _target
var _rotate_dir := -1
var health := 1
var _damage := 2
var should_move := false
var destination:Vector2
var direction:Vector2
signal died

func _ready():
	$Timer.start()
	$Timer2.start()
	_rotate_dir = -1 if randi()%2 == 0 else 1
	$Ram.rotation_degrees = rand_range(0, 359)

func _process(_delta):
	_sprite.rotation_degrees += _rotate_dir
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

func hit(damage):
	if health > 0:
		$AudioStreamPlayer2D.play()
	health -= damage
	if health <= 0:
		emit_signal("died")
		$CollisionShape2D.set_deferred("disabled", true)
		var _error = $Tween.interpolate_property($Light2D, "energy", null, $Light2D.energy-1, 0.5)
		_error = $Tween.start()
		yield(get_tree().create_timer(0.25), "timeout")
		_error = $Tween.interpolate_property(self, "modulate", null, Color(0,0,0,0), 0.5)
		_error = $Tween.start()
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()

func _on_Area2D_body_entered(body):
	if body is Player and health > 0:
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
	$Ram.rotation_degrees = rad2deg(direction.angle())+90
