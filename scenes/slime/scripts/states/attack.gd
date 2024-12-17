extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var hit = false

func _ready():
	super()
	anim_name = "attack"

func enter_state():
	super()
	anim.play(anim_name)
	hit = false

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	unit.velocity.x = 0
	if anim.frame == 2:
		$"../../Area2D2_AttackBox/CollisionShape2D".disabled = false
	if anim.frame == 4:
		$"../../Area2D2_AttackBox/CollisionShape2D".disabled = true
		if !hit:
			if unit.target.is_in_group("Player"):
				if unit.target.has_method("take_damage"):
					unit.target.take_damage(25)
					hit = true
		await get_tree().create_timer(0.25).timeout
		if unit.target:
			statemachine.set_state("chase")
		else:
			statemachine.set_state("idle")

func loop_process(delta):
	pass
