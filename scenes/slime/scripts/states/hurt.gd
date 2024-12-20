extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "hurt"

func enter_state():
	super()
	anim.play(anim_name)

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	if unit.health <= 0:
		statemachine.set_state("die")
	else:
		if anim.frame == 2:
			statemachine.set_state("roam")

func loop_process(delta):
	pass
