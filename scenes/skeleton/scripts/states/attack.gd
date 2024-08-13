extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var rand_attack
var dir

var target

func _ready():
	super()
	anim_name = "attack"
	if anim.flip_h:
		$"../../Area2D_AttackArea/CollisionShape2D".position = Vector2(-10, -20)
		dir = -1
	else:
		$"../../Area2D_AttackArea/CollisionShape2D".position = Vector2(10, -20)
		dir = 1
	
func enter_state():
	super()
	stop()
	rand_attack = anim_name + str(randi_range(1, 3))
	anim.play(rand_attack)

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	#if unit.is_on_floor():
		#unit.velocity.x = 0

func loop_process(delta):
	if anim.flip_h:
		$"../../Area2D_AttackArea/CollisionShape2D".position = Vector2(-10, -20)
		dir = -1
	else:
		$"../../Area2D_AttackArea/CollisionShape2D".position = Vector2(10, -20)
		dir = 1
	
	match rand_attack:
		"attack1":
			if anim.frame == 1:
				stop()
			if anim.frame == 4:
				$"../../Area2D_AttackArea/CollisionShape2D".disabled = false
				leap(delta)
			if anim.frame == 5:
				$"../../Area2D_AttackArea/CollisionShape2D".disabled = true
			if anim.frame == 6:
				stop()
				statemachine.set_state("chase")
		"attack2":
			if anim.frame == 1:
				stop()
			if anim.frame == 2:
				$"../../Area2D_AttackArea/CollisionShape2D".disabled = false
				leap(delta)
			if anim.frame == 3:
				$"../../Area2D_AttackArea/CollisionShape2D".disabled = true
			if anim.frame == 6:
				stop()
				statemachine.set_state("chase")
		"attack3":
			if anim.frame == 1:
				stop()
			if anim.frame == 4:
				$"../../Area2D_AttackArea/CollisionShape2D".disabled = false
				leap(delta)
			if anim.frame == 5:
				$"../../Area2D_AttackArea/CollisionShape2D".disabled = true
				stop()
			if anim.frame == 8:
				$"../../Area2D_AttackArea/CollisionShape2D".disabled = false
			if anim.frame == 9:
				$"../../Area2D_AttackArea/CollisionShape2D".disabled = true
			if anim.frame == 12:
				statemachine.set_state("chase")

func leap(delta):
	#unit.velocity.y = -125
	unit.velocity.x = unit.chase_speed * 1.5 * dir * delta

func stop():
	unit.velocity.x = 0

func get_target():
	target = unit.detect_player()
