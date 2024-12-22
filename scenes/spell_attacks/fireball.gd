extends RigidBody2D

var speed = 0
var dir = Vector2.ZERO

var hit = false

const EXPLOSION = preload("res://scenes/spell_attacks/explosion.tscn")

func _ready():
	pass

func _physics_process(delta):
	rotation = dir.angle()
	speed += delta * 180
	var collide = move_and_collide(dir * speed * delta)
	if collide and !hit:
		hit = true
		var collider = collide.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(25)
		var gpos = collide.get_position()
		spawn_explosion_vfx()
		set_collision_layer_value(2, false)
		visible = false
		freeze = true
		$AudioStreamPlayer2D.play()
		$Timer.start()

func spawn_explosion_vfx():
	var explosion = EXPLOSION.instantiate()
	explosion.global_position = global_position
	get_tree().root.add_child(explosion)

func _on_timer_timeout():
	call_deferred("queue_free")
