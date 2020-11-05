extends StaticBody2D

const enemy := preload("res://Enemies/Normal_Enemy.tscn")
const  ram := preload("res://Enemies/Ram.tscn")
export var type := "Sword"
var health := 5
var enemies := 0
var max_enemies:int
signal create_enemy(enemy)
signal spawner_cleared

func _on_Timer_timeout():
	if enemies < max_enemies and health > 0:
		var Enemy := enemy.instance() if type == "Sword" else ram.instance()
		Enemy.position = get_global_transform().origin
		var _error = Enemy.connect("died", self, "spawn_died")
		emit_signal("create_enemy", Enemy)
		enemies += 1
	elif health <= 0:
		if enemies == 0:
			emit_signal("spawner_cleared")
			enemies = -1

func spawn_died():
	enemies -= 1

func hit(damage):
	health -= damage
	if health <= 0:
		hide()

func _on_Area2D_body_entered(body):
	if body is Player:
		$Timer.start()
