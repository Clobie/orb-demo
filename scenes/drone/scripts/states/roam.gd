extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 0.0

var can_scan_state_change = true

func _ready():
	super()
	anim_name = "roam"

func enter_state():
	super()
	if unit.can_scan:
		anim.play("chase")
	else:
		anim.play(anim_name)
	timeout = randf_range(5.0, 15.0)
	unit.velocity.x = (randi() % 2) * 2 - 1
	unit.velocity.y = (randi() % 2) * 2 - 1
	unit.velocity = unit.velocity.normalized() * unit.speed

func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	if unit.can_scan:
		anim.play("chase")
		
	time += delta
	if time > timeout:
		statemachine.set_state("idle")
		time = 0
	elif unit.target:
		statemachine.set_state("chase")
	else:
		var dir = unit.get_biased_roam_direction()
		var hspeed = unit.speed * unit.horizontal_speed_multiplier
		var hspeed_ramp = unit.speed_ramp * unit.horizontal_speed_multiplier
		var vspeed = unit.speed * unit.vertical_speed_multiplier
		var vspeed_ramp = unit.speed_ramp * unit.vertical_speed_multiplier
		unit.velocity.x = clamp(unit.velocity.x + (dir.x * delta * hspeed_ramp), -hspeed, hspeed)
		unit.velocity.y = clamp(unit.velocity.y + (dir.y * delta * vspeed_ramp), -vspeed, vspeed)
	
	if unit.target:
		statemachine.set_state("chase")
	
	
