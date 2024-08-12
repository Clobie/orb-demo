extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var dir = 0

func _ready():
	super()
	anim_name = "walk"

func enter_state():
	super()
	anim.play(anim_name)
	while dir == 0:
		dir = randi_range(-1, 1)

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	roam(delta)

func loop_process(delta):
	var p = unit.detect_player()
	if p:
		statemachine.set_state("chase")

func roam(delta):
	if unit.on_edge() or unit.near_wall():
		dir *= -1
	unit.velocity.x = dir * unit.roam_speed * delta
	if unit.velocity.x < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
