extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "idle"

func enter_state():
	super()
	anim.play(anim_name)

func exit_state():
	pass

func loop_physics_process(delta):
	if unit.jump():
		statemachine.set_state("jump")
	if unit.move_axis():
		statemachine.set_state("run")
	if unit.shoot():
		statemachine.set_state("shoot")
	unit.apply_gravity(delta)
	if unit.is_on_floor():
		unit.velocity.x = 0
		unit.can_jump = true
		unit.can_double_jump = true
	else:
		statemachine.set_state("fall")

func loop_process(_delta):
	pass
