extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name

var time = 0.0
var timeout = 0.035

var full_text = [
	"Your persistence will only fuel your demise!!                    ",
	" "
]
var current_text = ""
var current_line = 0  # Start with the first line
var letter_index = 0  # Track the position in the current line
var typing_speed = 0.1  # Time in seconds between letters

func _ready():
	super()
	anim_name = "idle"

func enter_state():
	super()
	anim.play(anim_name)
	unit.set_collision_layer_value(2, false)
	unit.engaged = true
	talk()
	unit.global_position = unit.target.global_position + Vector2(0, -10)
	unit.velocity = Vector2.ZERO
	await get_tree().create_timer(3.0).timeout
	anim.material.set_shader_parameter("greyscale", false)
	anim.material.set_shader_parameter("dissolve", false)
	anim.material.set_shader_parameter("alpha", 1.0)
	anim.material.set_shader_parameter("chroma_offset", false)

func exit_state():
	pass

func loop_physics_process(delta):
	unit.velocity = Vector2.ZERO
	time += delta
	if time > timeout:
		time = 0.0
		say_stuff()

func loop_process(delta):
	pass

func talk():
	if current_line < full_text.size():
		current_text = ""
		letter_index = 0

func say_stuff():
	if current_line < full_text.size():
		if letter_index < full_text[current_line].length():
			current_text += full_text[current_line][letter_index]
			letter_index += 1
			unit.label.text = current_text
		else:
			current_line += 1
			if current_line == 2:
				timeout = 0.025
			letter_index = 0
			current_text = ""
	else:
		statemachine.set_state("attack6")
