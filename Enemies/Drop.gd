class_name Drop
extends Area2D

var type := "Ram"

func _ready():
	change_type()

func change_type():
	$Blade1/AnimatedSprite.play(type)
	if type == "Dual":
		$Blade2.visible = true
	else:
		$Blade2.visible = false

func _on_Drop_body_entered(body):
	if body is Player:
		var change_to = body.sword.type
		body.new_weapon(type)
		diff_weapon(change_to)

func diff_weapon(new_type):
	type = new_type
	if type != "Sword":
		change_type()
	else:
		queue_free()
