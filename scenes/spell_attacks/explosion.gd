extends Node2D

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	if $AnimatedSprite2D.frame == 7:
		call_deferred("queue_free")
