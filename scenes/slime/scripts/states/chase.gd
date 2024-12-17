extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 0.0
var dir = 0

func _ready():
	super()
	anim_name = "move"

func enter_state():
	super()
	anim.play(anim_name)
	timeout = randf_range(1.0, 5.0)
	time = 0
	unit.velocity.x = 0

func exit_state():
	pass

func loop_physics_process(delta):
	if !unit.target:
		statemachine.set_state("idle")
	if unit.target:
		unit.apply_gravity(delta)
		var tpos = unit.target.global_position
		var lpos = unit.global_position
		var dist = tpos.distance_to(lpos)
		var d = tpos - lpos
		if abs(d.x) < 30 and abs(d.y) < 30:
			statemachine.set_state("attack")
		elif dist > unit.chase_distance:
			unit.target = null
			statemachine.set_state("idle")
		elif abs(d.y) > 30 and unit.target.is_on_floor():
			unit.target = null
			statemachine.set_state("idle")
		else:
			if unit.ray_cast_2d_floor.is_colliding() and !unit.ray_cast_2d_wall.is_colliding():
				unit.velocity.x = d.normalized().x * unit.chase_speed * delta
			else:
				unit.velocity.x = 0

func loop_process(delta):
	pass
