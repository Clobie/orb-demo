extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 0.0

var aggro_timer = 0.0
var aggro_timer_timeout = 10.0

func _ready():
	super()
	anim_name = "chase"
	aggro_timer = 0.0

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
			unit.can_scan = true
			aggro_timer = 0.0
			statemachine.set_state("roam")
		else:
			var dir = unit.get_biased_roam_direction()
			if dist < 55 and unit.target.velocity.length() < 5:
				aggro_timer = 0.0
				statemachine.set_state("scan")
			else:
				aggro_timer += delta
				if aggro_timer > aggro_timer_timeout:
					aggro_timer = 0.0
					statemachine.set_state("attack")
				unit.velocity.x = clamp(unit.velocity.x + (dir.x * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
				unit.velocity.y = clamp(unit.velocity.y + (dir.y * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
	else:
		statemachine.set_state("roam")
