extends Node2D

onready var _button := $AnimationPlayer
export var type := "A2"

func _process(_delta):
	_button.play(type)
