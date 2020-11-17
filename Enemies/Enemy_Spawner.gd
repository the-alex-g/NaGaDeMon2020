extends StaticBody2D

const drop := preload("res://Enemies/Drop.tscn")
const sword := preload("res://Enemies/Sword.tscn")
const ram := preload("res://Enemies/Ram.tscn")
const swarm := preload("res://Enemies/Swarm.tscn")
const hulk := preload("res://Enemies/Hulk.tscn")
export var type := "Sword"
export var level := "1"
var health := 5
var enemies := 0
var spawn_rate := 1.0
var dead := false
var max_enemies:int
var rotate_dir := 0
signal create_enemy(enemy)
signal spawner_cleared(level)
signal spawn_drop(drop)

func _ready():
	rotate_dir = -1 if randi()%2 == 0 else 1
	$SpawnLocationArm/AnimatedSprite.hide()

func _process(_delta):
	$Sprite.rotation_degrees += rotate_dir

func _on_Timer_timeout():
	if enemies < max_enemies and not dead:
		var Enemy := sword.instance() if type == "Sword" else ram.instance() if type == "Ram" else swarm.instance() if type == "Swarm" else hulk.instance()
		_get_new_arm_location()
		var alternate_position := Vector2(0,0)
		var space_state := get_world_2d().direct_space_state
		var result := space_state.intersect_ray(self.get_global_transform().origin, $SpawnLocationArm/SpawnLocation.get_global_transform().origin)
		if result:
			alternate_position = result.position
		$SpawnLocationArm/AnimatedSprite.show()
		$Timer2.start()
		Enemy.position = $SpawnLocationArm/SpawnLocation.get_global_transform().origin if alternate_position == Vector2.ZERO else alternate_position
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
	if health > 0:
		$AudioStreamPlayer2D.play()
	if health <= 0 and not dead:
		dead = true
		$CollisionShape2D.set_deferred("disabled", true)
		var _error = $Tween.interpolate_property(self, "modulate", null, Color(0,0,0,0), 0.5)
		_error = $Tween.start()
		if type != "Sword":
			yield(get_tree().create_timer(0.5), "timeout")
			var Drop = drop.instance()
			Drop.position = self.get_global_transform().origin
			Drop.diff_weapon(type)
			emit_signal("spawn_drop", Drop)

func _on_Area2D_body_entered(body):
	if body is Player:
		$Timer.start(spawn_rate)

func _on_Timer2_timeout():
	$SpawnLocationArm/AnimatedSprite.hide()
	$Timer2.stop()
