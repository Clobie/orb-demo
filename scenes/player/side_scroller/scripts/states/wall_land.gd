extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "wall_land"

func enter_state():
	anim.play(anim_name)
	unit.can_double_jump = false
	unit.can_wall_jump = true
	unit.velocity.y = 0
	#unit.velocity.x = 0

func exit_state():
	pass

func loop_physics_process(delta):
	if anim.frame == 5:
		statemachine.set_state("wall_hold")
	elif unit.is_on_floor():
		statemachine.set_state("idle")
	elif !unit.can_wall_hold():
		statemachine.set_state("fall")
	elif unit.wall_jump():
		statemachine.set_state("wall_jump")
	elif unit.is_crouching():
		unit.apply_gravity(delta*0.05)
	else:
		pass#unit.apply_gravity(delta*0.05)

func loop_process(_delta):
	pass
