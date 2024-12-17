extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 2.0

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
	time += delta
	if unit.target.health <= 0 or time >= timeout:
		unit.target = null
		unit.scan_attempts = 0
		unit.laser.deactivate()
		unit.can_scan = true
		unit.prog_bar_angry.visible = false
		time = 0
		statemachine.set_state("roam")
		
	if unit.target:
		unit.prog_bar_angry.visible = true
		var dist = unit.target.global_position.distance_to(unit.global_position)
		var move_dir = unit.get_biased_roam_direction()
		var player_dir = ((unit.target.global_position + Vector2(0, -10)) - unit.global_position).normalized()
		unit.laser.activate()
		unit.laser.rotation = player_dir.angle()
		if dist < 150:
			#attack
			pass
		else:
			unit.velocity.x = clamp(unit.velocity.x + (move_dir.x * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
			unit.velocity.y = clamp(unit.velocity.y + (move_dir.y * delta * unit.chase_speed_ramp), -unit.chase_speed, unit.chase_speed)
	else:
		statemachine.set_state("roam")
