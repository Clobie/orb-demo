extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var dir = 0
var target

func _ready():
	super()
	anim_name = "walk"

func enter_state():
	super()
	anim.play(anim_name)
	get_target()

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	chase(delta)

func loop_process(delta):
	get_target()
		
func chase(delta):
	if target:
		var d = (target.global_position - unit.global_position).x
		if abs(d) < 45 * $"../..".scale.x:
			statemachine.set_state("attack")
			return
		if d < 0: dir = -1
		if d > 0: dir = 1
		unit.velocity.x = dir * unit.chase_speed * delta
		if unit.velocity.x < 0:
			anim.flip_h = true
			#$"../../Area2D_AttackArea/CollisionShape2D".position = Vector2(-10, -20)
		else:
			anim.flip_h = false
			#$"../../Area2D_AttackArea/CollisionShape2D".position = Vector2(10, -20)
	else:
		statemachine.set_state("roam")
		
func get_target():
	target = unit.detect_player()
