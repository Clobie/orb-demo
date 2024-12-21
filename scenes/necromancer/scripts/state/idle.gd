extends State_CharacterBody2D


# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name

func _ready():
	super()
	anim_name = "idle"

func enter_state():
	super()
	anim.play(anim_name)
	unit.velocity = Vector2.ZERO
	unit.set_collision_layer_value(2, true)
	
	anim.material.set_shader_parameter("greyscale", false)
	anim.material.set_shader_parameter("dissolve", false)
	anim.material.set_shader_parameter("alpha", 1.0)
	anim.material.set_shader_parameter("chroma_offset", false)
	
	unit.point_light_2d.blend_mode = 0
	unit.point_light_2d.energy = 0.75
	
	await get_tree().create_timer(2.0).timeout
	statemachine.set_state("dialogue")

func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	pass
