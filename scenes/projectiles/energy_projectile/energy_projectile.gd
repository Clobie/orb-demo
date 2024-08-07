extends CharacterBody2D

@onready var explosion = preload("res://scenes/projectiles/energy_projectile/explosion.tscn")
@export var speed: float = 800.0
var direction: Vector2

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

func _on_area_2d_body_entered(body):
	var x = explosion.instantiate()
	#x.global_position = global_position
	add_child(x)
	direction = Vector2(0,0)
	$Sprite2D.visible = false
	$PointLight2D.visible = false
	$Timer.start()
	$GPUParticles2D.emitting = false

func _on_timer_timeout():
	call_deferred("queue_free")
