extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var dir = 0
var destination: Vector2

func _ready():
	super()
	anim_name = "idle"

func enter_state():
	super()
	anim.play(anim_name)
	unit.velocity = Vector2.ZERO
	unit.set_collision_layer_value(2, false)
	
	var teleport_time = 2.0
	var destination = unit.target.global_position + Vector2(randf_range(-75, 75), -75)
	
	var prev_dissolve = anim.material.get_shader_parameter("dissolve")
	var prev_dissolve_level = anim.material.get_shader_parameter("dissolve_level")
	var prev_alpha = anim.material.get_shader_parameter("alpha")
	
	#disappear
	anim.material.set_shader_parameter("dissolve", true)
	create_tween().tween_method(func(value): anim.material.set_shader_parameter("dissolve_level", value), prev_dissolve_level, 1.0, teleport_time / 2.0)
	create_tween().tween_method(func(value): anim.material.set_shader_parameter("alpha", value), prev_alpha, 0.0, teleport_time / 2.0)
	
	# wait 5 seconds
	await get_tree().create_timer(teleport_time / 2.0).timeout
	var state = statemachine.get_state()
	if state.name != 'teleport':
		return
	
	# teleport
	unit.global_position = destination
	
	#reappear
	create_tween().tween_method(func(value): anim.material.set_shader_parameter("dissolve_level", value), 1.0, prev_dissolve_level, teleport_time / 2.0)
	create_tween().tween_method(func(value): anim.material.set_shader_parameter("alpha", value), 0.0, prev_alpha, teleport_time / 2.0)
	
	# wait 5 seconds
	await get_tree().create_timer(teleport_time / 2.0).timeout
	state = statemachine.get_state()
	if state.name != 'teleport':
		return
	anim.material.set_shader_parameter("dissolve", prev_dissolve)
	
	if unit.engaged:
		if !unit.can_see_player():
			statemachine.set_state("teleport")
		else:
			if unit.health > unit.health_max / 2:
				var attacks = ["attack1", "attack2", "attack3", "attack4"]
				var random_index = randi() % attacks.size()
				statemachine.set_state(attacks[random_index])
			else:
				var attacks = ["attack1", "attack2", "attack3", "attack4", "attack5", "attack6"]
				var random_index = randi() % attacks.size()
				statemachine.set_state(attacks[random_index])
		unit.set_collision_layer_value(2, true)
	else:
		statemachine.set_state("stalk")
	
func exit_state():
	pass
