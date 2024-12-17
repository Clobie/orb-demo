extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 0.0

func _ready():
	super()
	anim_name = "idle"

func enter_state():
	super()
	anim.play(anim_name)
	timeout = randf_range(1.0, 5.0)
	time = 0
	unit.velocity.x = 0

func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	unit.apply_gravity(delta)
	time += delta
	if time > timeout:
		statemachine.set_state("roam")
		time = 0
	elif unit.target:
		statemachine.set_state("chase")
