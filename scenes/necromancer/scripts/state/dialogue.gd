extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name

var time = 0.0
var timeout = 0.075

var full_text = [
	"Your curiosity...                                   ",
	"... Will be your undoing.                           ",
	" "
]
var current_text = ""
var current_line = 0  # Start with the first line
var letter_index = 0  # Track the position in the current line
var typing_speed = 0.1  # Time in seconds between letters

func _ready():
	super()
	anim_name = "idle"
	unit.engaged = true

func enter_state():
	super()
	anim.play(anim_name)
	unit.set_collision_layer_value(2, false)
	talk()  # Start the dialog when entering the state

func exit_state():
	pass

func loop_physics_process(delta):
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
		statemachine.set_state("chase")
