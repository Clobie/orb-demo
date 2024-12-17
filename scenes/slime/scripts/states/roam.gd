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
	timeout = randf_range(5.0, 20.0)
	time = 0
	dir = (randi() % 2) * 2 - 1

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	if unit.target:
		statemachine.set_state("chase")
	if time >= timeout:
		statemachine.set_state("idle")
	
	if !unit.ray_cast_2d_floor.is_colliding() or unit.ray_cast_2d_wall.is_colliding():
		dir = dir * -1
	unit.velocity.x = dir * (unit.chase_speed / 2) * delta
	
func loop_process(delta):
	pass
