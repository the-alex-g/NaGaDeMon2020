extends Area2D

export var location := 1
export var destination := 2
signal entered(destination, location)

func _on_Portal_body_entered(body):
	if body is Player:
		emit_signal("entered", destination, location)
