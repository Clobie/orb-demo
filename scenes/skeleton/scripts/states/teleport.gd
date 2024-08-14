extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var dir = 0
var target

func _ready():
	super()
	anim_name = "idle"

func enter_state():
	super()
	anim.play(anim_name)
	unit.velocity.x = 0
	var material = $"../../AnimatedSprite2D".material
	$"../../Node2D/ProgressBar_Red".visible = false
	$"../../Node2D/ProgressBar_Green".visible = false
	$"../../Node2D/ColorRect".visible = false
	$"../../Node2D/ColorRect2".visible = false
	create_tween().tween_method(
		func(value): 
			material.set_shader_parameter("progress", value), 
			0.0, 
			1.0, 
			0.25
	)
	await get_tree().create_timer(1.0).timeout
	unit.global_position = unit.target.global_position
	create_tween().tween_method(
		func(value): 
			material.set_shader_parameter("progress", value), 
			1.0, 
			0.0, 
			0.25
	)
	$"../../Node2D/ProgressBar_Red".visible = true
	$"../../Node2D/ProgressBar_Green".visible = true
	$"../../Node2D/ColorRect".visible = true
	$"../../Node2D/ColorRect2".visible = true
	#await get_tree().create_timer(1.0).timeout
	statemachine.set_state("attack")
	
func exit_state():
	pass

func loop_physics_process(delta):
	unit.apply_gravity(delta)

func loop_process(delta):
	pass
