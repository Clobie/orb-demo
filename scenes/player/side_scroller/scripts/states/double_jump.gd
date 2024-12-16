extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

@onready var change_dir_once: bool = false

func _ready():
	super()
	anim_name = "air_roll"

func enter_state():
	anim.play(anim_name)
	unit.velocity.y = -unit.double_jump_force
	unit.can_double_jump = false
	if unit.move_axis() != 0:
		change_dir_once = true
	unit.play_random_jump_sound()

func exit_state():
	pass

func loop_physics_process(delta):
	if unit.is_on_floor():
		unit.can_double_jump = true
		statemachine.set_state("idle")
	elif unit.is_on_wall() and unit.velocity.y > 0 and unit.can_ledge_hold():
		statemachine.set_state("ledge_land")
	elif unit.is_on_wall() and unit.velocity.y > 0 and unit.can_wall_hold():
		statemachine.set_state("wall_land")
	elif anim.frame == 5:
		statemachine.set_state("fall")
	else:
		unit.apply_gravity(delta)
		unit.velocity.x = clamp(
			unit.velocity.x + unit.move_axis() * unit.run_speed * delta * 0.1,
			-unit.run_speed * delta,
			unit.run_speed * delta
		)
		if change_dir_once:
			change_dir_once = false
			#unit.velocity.x = unit.move_axis() * unit.run_speed * delta / 2.0
		if unit.is_on_floor():
			unit.can_jump = true
			unit.can_double_jump = true

func loop_process(_delta):
	pass
