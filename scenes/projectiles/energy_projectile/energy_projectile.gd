extends RigidBody2D

@onready var explosion = preload("res://scenes/projectiles/energy_projectile/explosion.tscn")
@export var speed: float = 800.0
var direction: Vector2
var bounces = 0

func _ready():
	pass

func _physics_process(delta):
	var collide = move_and_collide(direction * speed * delta)
	if collide:
		var collider = collide.get_collider()
		var gpos = collide.get_position()
		if bounces == 0:
			explode()
			$CollisionShape2D.disabled = true
		else:
			bounces -= 1
			direction = direction.bounce(collide.get_normal()) * Vector2(1, 0.7)
		if collider.has_method("hit"):
			collider.hit(collider, gpos)
		damage(collide.get_collider(), collide.get_position())

func damage(collider, gpos):
	if collider.has_method("take_damage"):
		collider.take_damage(randi_range(15,25))

func explode():
	var x = explosion.instantiate()
	add_child(x)
	direction = Vector2(0,0)
	$Sprite2D.visible = false
	$PointLight2D.visible = false
	$Timer.start()
	$GPUParticles2D.emitting = false
	$GPUParticles2D2.emitting = true

func _on_timer_timeout():
	call_deferred("queue_free")
