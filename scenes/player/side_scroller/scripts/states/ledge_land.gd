extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "ledge_land"

func enter_state():
	anim.play(anim_name)
	#unit.velocity.x = 0
	unit.velocity.y = 0
	unit.can_double_jump = false
	unit.can_wall_jump = true

func exit_state():
	pass

func loop_physics_process(_delta):
	if anim.frame == 1:
		statemachine.set_state("ledge_hold")
	if unit.double_jump():
		statemachine.set_state("double_jump")
	elif unit.wall_jump():
		statemachine.set_state("wall_jump")

func loop_process(_delta):
	pass
