extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 3.0

func _ready():
	super()
	anim_name = "idle"

func enter_state():
	super()
	anim.play(anim_name)

func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	time += delta
	if time > timeout:
		unit.target = null
		statemachine.set_state("roam")
		time = 0
		
	if unit.target:
		if unit.target.velocity.length() > 5:
			statemachine.set_state("chase")
			time = 0
		var dist = unit.target.global_position.distance_to(unit.global_position)
		if dist > unit.chase_distance:
			unit.target = null
			statemachine.set_state("roam")
		else:
			var dir = unit.get_biased_roam_direction()
			if dist < 55:
				unit.velocity = lerp(unit.velocity, Vector2.ZERO, 5 * delta)
			else:
				unit.velocity.x = clamp(unit.velocity.x + (dir.x * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
				unit.velocity.y = clamp(unit.velocity.y + (dir.y * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
	else:
		statemachine.set_state("roam")
