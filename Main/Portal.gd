extends Area2D

export var location := 1
export var destination := 2
export var portal_number := 1
signal entered(destination, location)

func _ready():
	if portal_number == 1:
		$AnimatedSprite.play("Blue")
	else:
		$AnimatedSprite.play("Yellow")

func _on_Portal_body_entered(body):
	if body is Player:
		emit_signal("entered", destination, location)
