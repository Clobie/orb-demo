extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "shoot"

func enter_state():
	anim.play(anim_name)
	if unit.is_on_floor():
		unit.velocity.x = 0

func exit_state():
	pass

func loop_physics_process(delta):
	if unit.is_on_floor():
		unit.velocity.x = 0
	if anim.frame == 4:
		statemachine.set_state("idle")
	elif unit.shoot() and anim.frame >= 3:
		anim.frame = 0
	unit.apply_gravity(delta)

func loop_process(_delta):
	pass
