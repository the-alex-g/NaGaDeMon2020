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
var rotate_dir := 0
signal create_enemy(enemy)
signal spawner_cleared(level)

func _ready():
	rotate_dir = -1 if randi()%2 == 0 else 1

func _process(_delta):
	$Sprite.rotation_degrees += rotate_dir

func _on_Timer_timeout():
	if enemies < max_enemies and health > 0:
		var Enemy := sword.instance() if type == "Sword" else ram.instance() if type == "Ram" else swarm.instance() if type == "Swarm" else hulk.instance()
		_get_new_arm_location()
		
		if $SpawnLocationArm/RayCast2D.is_colliding():
			_get_new_arm_location()
		Enemy.position = $SpawnLocationArm/SpawnLocation.get_global_transform().origin
		var _error = Enemy.connect("died", self, "spawn_died")
		emit_signal("create_enemy", Enemy)
		enemies += 1
	elif health <= 0:
		if enemies == 0:
			emit_signal("spawner_cleared", level)
			enemies = -1

func _get_new_arm_location():
	$SpawnLocationArm.rotation_degrees = rand_range(1,360)

func spawn_died():
	enemies -= 1

func hit(damage):
	health -= damage
	if health <= 0:
		hide()

func _on_Area2D_body_entered(body):
	if body is Player:
		$Timer.start(spawn_rate)
