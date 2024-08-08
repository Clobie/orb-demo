extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "ledge_hold"

func enter_state():
	anim.play(anim_name)
	unit.can_double_jump = false
	unit.can_wall_jump = true
	unit.velocity.x = 0
	unit.velocity.y = 0

func exit_state():
	pass

func loop_physics_process(delta):
	if unit.double_jump():
		statemachine.set_state("double_jump")
	if unit.wall_jump():
		statemachine.set_state("wall_jump")
	elif unit.is_crouching():
		unit.apply_gravity(delta*0.05)
		if !unit.can_ledge_hold():
			statemachine.set_state("fall")

func loop_process(_delta):
	pass
