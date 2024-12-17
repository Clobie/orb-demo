extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 0.0

func _ready():
	super()
	anim_name = "chase"

func enter_state():
	super()
	anim.play(anim_name)

func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	if unit.target:
		var dist = unit.target.global_position.distance_to(unit.global_position)
		if dist > unit.chase_distance:
			unit.target = null
			statemachine.set_state("roam")
		else:
			var dir = unit.get_biased_roam_direction()
			if dist < 55 and unit.target.velocity.length() < 5:
				statemachine.set_state("scan")
			else:
				unit.velocity.x = clamp(unit.velocity.x + (dir.x * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
				unit.velocity.y = clamp(unit.velocity.y + (dir.y * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
	else:
		statemachine.set_state("roam")
