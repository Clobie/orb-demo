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
	if time >= timeout:
		unit.target = null
		unit.prog_bar.visible = false
		statemachine.set_state("roam")
		time = 0
		unit.scan_attempts = 0
		$"../../AudioStreamPlayer2D2".play()
		statemachine.set_state("roam")
		
	if unit.target:
		if unit.target.velocity.length() > 5:
			unit.prog_bar.visible = false
			time = 0
			unit.scan_attempts += 1
			if unit.scan_attempts >= unit.max_scan_attempts:
				time = 0
				unit.prog_bar.visible = false
				statemachine.set_state("attack")
			else:
				statemachine.set_state("chase")
			
		var dist = unit.target.global_position.distance_to(unit.global_position)
		if dist > unit.chase_distance:
			unit.target = null
			unit.prog_bar.visible = false
			time = 0
			unit.can_scan = true
			statemachine.set_state("roam")
		else:
			var dir = unit.get_biased_roam_direction()
			if dist < 55:
				unit.velocity = lerp(unit.velocity, Vector2.ZERO, 5 * delta)
				unit.prog_bar.visible = true
				unit.prog_bar.value = time * (100.0 / timeout)
			else:
				time = 0
				unit.prog_bar.visible = false
				unit.prog_bar.value = 0
				unit.velocity.x = clamp(unit.velocity.x + (dir.x * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
				unit.velocity.y = clamp(unit.velocity.y + (dir.y * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
	else:
		unit.prog_bar.visible = false
		statemachine.set_state("roam")
	
	time += delta
