extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

func _ready():
	super()
	anim_name = "death"

func enter_state():
	super()
	anim.play(anim_name)
	unit.velocity.x = 0
	$"../../Area2D_AttackArea/CollisionShape2D".disabled = true
	
func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	unit.apply_gravity(delta)
