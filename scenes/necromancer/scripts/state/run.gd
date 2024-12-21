extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 0.0

func _ready():
	super()
	anim_name = "fly"

func enter_state():
	super()
	anim.play(anim_name)
	timeout = randf_range(0.0, 2.0)
	unit.velocity.x = (randi() % 2) * 2 - 1
	unit.velocity.y = (randi() % 2) * 2 - 1
	unit.velocity = unit.velocity.normalized() * unit.speed

func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	time += delta
	if time > timeout:
		time = 0.0
		if unit.health > unit.health_max / 2:
			var random_attack = randi() % 2  # Generate 0 or 1 randomly
			if random_attack == 0:
				statemachine.set_state("attack1")
			else:
				statemachine.set_state("attack2")
		else:
			var attacks = ["attack1", "attack2", "attack3", "attack3"]
			var random_index = randi() % attacks.size()
			statemachine.set_state(attacks[random_index])

	var dist = unit.target.global_position.distance_to(unit.global_position)
	if dist < 300:
		unit.velocity = lerp(unit.velocity, Vector2.ZERO, 5 * delta)
	else:
		var dir = unit.get_biased_escape_direction()
		var speed = unit.speed
		var speed_ramp = unit.speed_ramp
		unit.velocity.x = clamp(unit.velocity.x + (dir.x * delta * speed_ramp), -speed, speed)
		unit.velocity.y = clamp(unit.velocity.y + (dir.y * delta * speed_ramp), -speed, speed)
