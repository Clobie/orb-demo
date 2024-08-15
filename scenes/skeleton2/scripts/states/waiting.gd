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
	unit.velocity.x = 0

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	if unit.is_on_floor():
		unit.velocity.x = 0

func loop_process(delta):
	if unit.target:
		if unit.target.is_on_floor():
			statemachine.set_state("chase")
	else:
		statemachine.set_state("roam")
