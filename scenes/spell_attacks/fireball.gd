extends Node2D

var speed = 0
var dir = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	speed += 180 * delta
	global_position += dir * speed * delta
	rotation = dir.angle()

func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(25)
		call_deferred("queue_free")

func _on_area_2d_area_entered(area):
	call_deferred("queue_free")
