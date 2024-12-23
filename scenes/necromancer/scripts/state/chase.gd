extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var time = 0.0
var timeout = 0.0

func _ready():
	super()
	anim_name = "fly"

func enter_state():
	super()
	anim.play(anim_name)
	timeout = randf_range(1.0, 1.0)
	unit.velocity.x = (randi() % 2) * 2 - 1
	unit.velocity.y = (randi() % 2) * 2 - 1
	unit.velocity = unit.velocity.normalized() * unit.speed
	unit.set_collision_layer_value(2, true)
	
func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	time += delta
	if time > timeout:
		time = 0.0
		
		if !unit.dialogue2_done and unit.health < unit.health_max / 2.0:
			unit.dialogue2_done = true
			statemachine.set_state("dialogue2")
		elif !unit.can_see_player():
			statemachine.set_state("teleport")
		else:
			if unit.health > unit.health_max / 2:
				var attacks = ["attack2", "attack3", "attack4", "attack5"]
				var random_index = randi() % attacks.size()
				statemachine.set_state(attacks[random_index])
			else:
				var attacks = ["attack1", "attack3", "attack4", "attack5", "attack6"]
				var random_index = randi() % attacks.size()
				statemachine.set_state(attacks[random_index])

	var dist = unit.target.global_position.distance_to(unit.global_position)
	if dist < 100:
		unit.velocity = lerp(unit.velocity, Vector2.ZERO, 5 * delta)
	else:
		var dir = unit.get_biased_chase_direction()
		var speed = unit.speed
		var speed_ramp = unit.speed_ramp
		unit.velocity.x = clamp(unit.velocity.x + (dir.x * delta * speed_ramp), -speed, speed)
		unit.velocity.y = clamp(unit.velocity.y + (dir.y * delta * speed_ramp), -speed, speed)
