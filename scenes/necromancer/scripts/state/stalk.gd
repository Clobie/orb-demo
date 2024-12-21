extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 5.0
var alpha = 0.15
var dark_light_energy = 0.15
var flashing = false

func _ready():
	super()
	anim_name = "stalk"

func enter_state():
	super()
	anim.play(anim_name)
	unit.set_collision_layer_value(2, false)
	anim.material.set_shader_parameter("greyscale", true)
	anim.material.set_shader_parameter("dissolve", false)
	anim.material.set_shader_parameter("alpha", alpha)
	anim.material.set_shader_parameter("chroma_offset", false)

func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	
	time += delta
	if time > timeout:
		time = 0.0
		flash(2.0)
	if not flashing:
		var dist = unit.target.global_position.distance_to(unit.global_position)
		if dist < 125:
			unit.velocity = lerp(unit.velocity, Vector2.ZERO, 3* delta)
		elif dist > 350:
			statemachine.set_state("teleport")
		else:
			var dir = unit.get_biased_chase_direction()
			var speed = unit.speed
			var speed_ramp = unit.speed_ramp
			unit.velocity.x = clamp(unit.velocity.x + (dir.x * delta * speed_ramp), -speed, speed)
			unit.velocity.y = clamp(unit.velocity.y + (dir.y * delta * speed_ramp), -speed, speed)

func flash(duration):
	flashing = true
	create_tween().tween_property(unit.point_light_2d, "energy", 0.0, duration/4.0)
	unit.velocity = Vector2.ZERO
	anim.material.set_shader_parameter("alpha", 1.0)
	create_tween().tween_method(func(value): anim.material.set_shader_parameter("alpha", value), 1.0, alpha, duration/2.0)
	create_tween().tween_property(unit.point_light_2d, "energy", dark_light_energy, duration/4.0)
	flashing = false
