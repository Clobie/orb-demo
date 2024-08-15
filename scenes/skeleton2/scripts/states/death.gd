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
	$"../../Area2D_HurtArea/CollisionShape2D".disabled = true
	$"../../Area2D_DetectPlayer/CollisionShape2D".disabled = true
	$"../../Area2D_Deaggro/CollisionShape2D".disabled = true
	$"../../Rays/RayCast2D_Right".enabled = false
	$"../../Rays/RayCast2D_Left".enabled = false
	$"../../Rays/RayCast2D_FloorLeft".enabled = false
	$"../../Rays/RayCast2D_FloorRight".enabled = false
	$"../../Rays/RayCast2D_PlayerDetector".enabled = false
	
func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	unit.apply_gravity(delta)
