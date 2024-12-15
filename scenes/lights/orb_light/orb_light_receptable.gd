extends Area2D

var activated = false

func _ready():
	pass

func _process(_delta):
	pass

func _on_body_entered(body):
	if body.has_method("can_insert"):
		if body.can_insert():
			#var dir = (global_position - body.global_position).normalized()
			#body.global_position = $CollisionShape2D.global_position
			body.disable($CollisionShape2D.global_position)
			activated = true
			$AnimatedSprite2D.play("activating")
			await $AnimatedSprite2D.animation_finished
			$AnimatedSprite2D.play("charging")
			
func _on_body_exited(_body):
	pass
	#$AnimatedSprite2D.play("failure")
	#activated = false
