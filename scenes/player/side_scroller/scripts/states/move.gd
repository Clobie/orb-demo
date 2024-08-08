extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "run"

func enter_state():
	anim.play(anim_name)

func exit_state():
	pass

func loop_physics_process(delta):
	if !unit.move_axis():
		statemachine.set_state("idle")
	elif unit.jump():
		statemachine.set_state("jump")
	elif unit.shoot():
		statemachine.set_state("shoot")
	else:
		unit.velocity.x = unit.move_axis() * unit.run_speed * delta
		unit.apply_gravity(delta)
		if unit.is_on_floor():
			unit.can_jump = true
			unit.can_double_jump = true
		else:
			statemachine.set_state("fall")

func loop_process(_delta):
	pass
