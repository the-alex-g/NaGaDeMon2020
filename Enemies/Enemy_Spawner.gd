extends StaticBody2D

const sword := preload("res://Enemies/Sword.tscn")
const ram := preload("res://Enemies/Ram.tscn")
const swarm := preload("res://Enemies/Swarm.tscn")
const hulk := preload("res://Enemies/Hulk.tscn")
export var type := "Sword"
export var level := "1"
var health := 5
var enemies := 0
var spawn_rate := 1.0
var max_enemies:int
signal create_enemy(enemy)
signal spawner_cleared(level)

func _on_Timer_timeout():
	if enemies < max_enemies and health > 0:
		var Enemy := sword.instance() if type == "Sword" else ram.instance() if type == "Ram" else swarm.instance() if type == "Swarm" else hulk.instance()
		Enemy.position = get_global_transform().origin
		var _error = Enemy.connect("died", self, "spawn_died")
		emit_signal("create_enemy", Enemy)
		enemies += 1
	elif health <= 0:
		if enemies == 0:
			emit_signal("spawner_cleared", level)
			enemies = -1

func spawn_died():
	enemies -= 1

func hit(damage):
	health -= damage
	if health <= 0:
		hide()

func _on_Area2D_body_entered(body):
	if body is Player:
		$Timer.start(spawn_rate)
