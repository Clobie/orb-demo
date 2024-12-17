extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String


func _ready():
	super()
	anim_name = "die"

func enter_state():
	super()
	anim.play(anim_name)
	unit.velocity = Vector2.ZERO
	$"../../CollisionShape2D".set_deferred("disabled", true)
	$"../../Area2D_PlayerFinder/CollisionShape2D".set_deferred("disabled", true)
	$"../../Area2D2_AttackBox/CollisionShape2D".set_deferred("disabled", true)
	unit.target = null
	for i in range(2):
		var hp = unit.HP_ORB.instantiate()
		hp.global_position = unit.global_position + Vector2(randf_range(-40, 40), randf_range(-40, 40))
		get_tree().root.add_child(hp)
	for i in range(2):
		var en = unit.ENERGY_ORB.instantiate()
		en.global_position = unit.global_position + Vector2(randf_range(-40, 40), randf_range(-40, 40))
		get_tree().root.add_child(en)
	
func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	pass
