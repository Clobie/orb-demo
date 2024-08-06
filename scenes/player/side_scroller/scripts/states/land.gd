extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "land"

func enter_state():
	anim.play(anim_name)

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	unit.velocity.x = 0
	if anim.frame == 8:
		statemachine.set_state("idle")
	if unit.move_axis() != 0 and unit.is_on_floor():
		statemachine.set_state("run")
	if unit.jump():
		statemachine.set_state("jump")
	if !unit.is_on_floor():
		statemachine.set_state("fall")

func loop_process(delta):
	pass
