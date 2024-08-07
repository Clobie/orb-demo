extends CharacterBody2D

@onready var explosion = preload("res://scenes/projectiles/energy_projectile/explosion.tscn")
@export var speed: float = 800.0
var direction: Vector2
@onready var gpu_particles_2d_2 = $GPUParticles2D2

func _ready():
	pass

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

func _on_area_2d_body_entered(body):
	var x = explosion.instantiate()
	add_child(x)
	direction = Vector2(0,0)
	$Sprite2D.visible = false
	$PointLight2D.visible = false
	$Timer.start()
	$GPUParticles2D.emitting = false
	gpu_particles_2d_2.emitting = true

func _on_timer_timeout():
	call_deferred("queue_free")
