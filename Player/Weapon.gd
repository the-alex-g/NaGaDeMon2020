extends Node2D

onready var sprite := $Blade1/AnimatedSprite
onready var _blade2 := $Blade2
onready var _blade2_collider := $Blade2/Area2D/CollisionShape2D
var type := "Sword"
var damage := 1.0

func _ready():
	switch_type("Sword")

func switch_type(new_type:String):
	type = new_type
	sprite.play(type)
	if type == "Dual":
		_blade2_collider.disabled = false
		_blade2.visible = true
		damage = 0.5
	else:
		_blade2_collider.disabled = true
		_blade2.visible = false
		damage = 1
	if type == "Hammer":
		damage = 1.5
	elif type == "Ram":
		damage = 2
	elif type == "Sword":
		damage = 1

func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage)
