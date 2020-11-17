extends KinematicBody2D

export var speed := 150
export var minswingspeed := 0.2
export var maxswingspeed := 2.5
onready var _sight := $Sightrange
onready var _sprite := $Sprite
onready var _heads := $Heads
var _target
var swingdir1 := 1
var swingdir2 := 1
var swingdir3 := 1
var swinging1 := false
var swinging2 := false
var swinging3 := false
var _swingspeed1 := 0.0
var _swingspeed2 := 0.0
var _swingspeed3 := 0.0
var _rotate_dir := -1
var lives := 3
export var health := 5.0
export var _damage := 1.0
var should_move := false
signal died

func _ready():
	_new_head_dir()
	_rotate_dir = -1 if randi()%2 == 0 else 1
	for head in _heads.get_children():
		head.rotation_degrees = rand_range(0,359)

func _process(delta):
	if health > 0:
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
		for x in _heads.get_child_count():
			if get("swinging"+str(x+1)):
				if get("_swingspeed"+str(x+1)) < maxswingspeed:
					set("_swingspeed"+str(x+1), get("_swingspeed"+str(x+1))+0.1)
			else:
				if get("_swingspeed"+str(x+1)) > maxswingspeed:
					set("_swingspeed"+str(x+1), get("_swingspeed"+str(x+1))-0.1)
			_heads.get_child(x).rotation_degrees += get("_swingspeed"+str(x+1))*get("swingdir"+str(x+1))

func hit(damage):
	health -= damage
	if health <= 0:
		get_node("Heads/Head"+str(lives)).hide()
		get_node("Heads/Head"+str(lives)+"/Area2D/CollisionShape2D").set_deferred("disabled", true)
		lives -= 1
		#emit_signal("died")
		hide()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.ow(_damage)

func _new_head_dir():
	for x in _heads.get_child_count():
		var headswingdir := randi()%3
		if headswingdir == 0:
			set("swinging"+str(x+1), true)
			set("swingdir"+str(x+1), -1)
		elif headswingdir == 1:
			set("swinging"+str(x+1), false)
		elif headswingdir == 2:
			set("swinging"+str(x+1), true)
			set("swingdir"+str(x+1), 1)

func _on_Timer_timeout():
	_new_head_dir()

func _on_Sightrange_body_entered(body):
	if body is Player:
		should_move = true
		_target = body
