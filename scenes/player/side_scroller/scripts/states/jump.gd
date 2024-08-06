extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "jump_start"

func enter_state():
	anim.play(anim_name)
	unit.velocity.y = -unit.jump_force
	unit.can_jump = false

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	statemachine.set_state("fall")
	if unit.is_on_floor():
		unit.can_jump = true
		unit.can_double_jump = true

func loop_process(delta):
	pass
