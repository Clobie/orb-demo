extends State_CharacterBody2D

# meta-name: CharacterBody2D State Template
# meta-description: Predefined State Template
# meta-default: true
# meta-space-indent: 4

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
	pass

func loop_process(delta):
	pass
