extends RigidBody2D

var speed = 0
var ang_speed = 400
var dir = Vector2.ZERO

var launched = false

var time = 0.0
var timeout = 0.5

var stuck = false
@onready var timer = $Timer

func _ready():
	$AudioStreamPlayer2D.play()

func _physics_process(delta):
	
	if !launched:
		time += delta
		if time > timeout:
			launched = true
			$AudioStreamPlayer2D.play()

	if !stuck:
		rotation += ang_speed * delta
		if launched:
			speed += delta * 720
		var collide = move_and_collide(dir * speed * delta)
		if collide:
			var collider = collide.get_collider()
			var gpos = collide.get_position()
			stuck = true
			freeze = true
			$AudioStreamPlayer2D2.play()
			$AudioStreamPlayer2D3.play()
			timer.start()

func _on_timer_timeout():
	var t = create_tween().tween_method(func(value): $Sprite2D.material.set_shader_parameter("alpha", value), 1.0, 0.0, 0.5)
	await t.finished
	call_deferred("queue_free")

func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(35)
