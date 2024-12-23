extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var dir = 0

func _ready():
	super()
	anim_name = "chase"

func enter_state():
	super()
	anim.play(anim_name)
	$"../../Rays/RayCast2D_FloorLeft".enabled = false
	$"../../Rays/RayCast2D_FloorRight".enabled = false

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	chase(delta)

func loop_process(delta):
	pass
		
func chase(delta):
	if !unit.target:
		statemachine.set_state("idle")
	else:
		var tpos = unit.target.global_position
		var lpos = unit.global_position
		var d = tpos - lpos
		if abs(d.x) < 40 and abs(d.y) < 40:
			statemachine.set_state("attack")
			return
		if abs(d.y) >= 40 and unit.target.is_on_floor():
			statemachine.set_state("teleport")
			return
		if !unit.target.is_on_floor() and abs(d.x) < 40:
			statemachine.set_state("waiting")
			return
		else:
			if d.x < 0:
				dir = -1
			if d.x > 0:
				dir = 1
			unit.velocity.x = dir * unit.chase_speed * delta
			if unit.velocity.x < 0:
				anim.flip_h = true
			else:
				anim.flip_h = false
