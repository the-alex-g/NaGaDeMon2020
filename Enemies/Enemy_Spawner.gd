extends StaticBody2D

const enemy := preload("res://Enemies/Normal_Enemy.tscn")
var health := 5
var enemies := 0
signal create_enemy(enemy)

func _on_Timer_timeout():
	if enemies < 4:
		var Enemy := enemy.instance()
		Enemy.position = get_global_transform().origin
		Enemy.connect("died", self, "spawn_died")
		emit_signal("create_enemy", Enemy)
		enemies += 1

func spawn_died():
	enemies -= 1

func hit(damage):
	health -= damage
	if health <= 0:
		queue_free()

func _on_Area2D_body_entered(body):
	if body is Player:
		$Timer.start()
