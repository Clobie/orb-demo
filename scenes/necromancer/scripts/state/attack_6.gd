extends State_CharacterBody2D


# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name

var casted = false

func _ready():
	super()
	anim_name = "attack3"

func enter_state():
	super()
	casted = false
	anim.play(anim_name)

func exit_state():
	pass

func loop_physics_process(delta):
	if anim.frame == 11 and !casted:
		casted = true
		
		
		
	if anim.frame == 16:
		var next_states = ["chase", "run"]
		var random_index = randi() % next_states.size()
		statemachine.set_state(next_states[random_index])

func loop_process(delta):
	pass
