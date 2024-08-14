extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var dir = 0
var target

func _ready():
	super()
	anim_name = "chase"

func enter_state():
	super()
	anim.play(anim_name)
	get_target()
	$"../../Rays/RayCast2D_FloorLeft".enabled = false
	$"../../Rays/RayCast2D_FloorRight".enabled = false

func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)
	chase(delta)

func loop_process(delta):
	get_target()
		
func chase(delta):
	if target and unit.can_see_player(target):
		var dist = (target.global_position - unit.global_position)
		if abs(dist.x) < 25 * $"../..".scale.x:
				statemachine.set_state("attack")
				return
		if abs(dist.x) > 300:
			statemachine.set_state("roam")
		if abs(dist.y) > 50:
			unit.target = target
			statemachine.set_state("teleport")
		if dist.x < 0:
			dir = -1
		if dist.x > 0:
			dir = 1
		unit.velocity.x = dir * unit.chase_speed * delta
		if unit.velocity.x < 0:
			anim.flip_h = true
		else:
			anim.flip_h = false
	else:
		statemachine.set_state("roam")
		
func get_target():
	var t = unit.detect_player()
	if t:
		target = t
