extends State_CharacterBody2D


# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name

var time = 0.0
var timeout = 6.86
var harm_start = 2.6
var harm_stop = 4.5

var harm_started = false
var harm_ended = false

var casted = false

var beam_ang = 0

var beam_rotations_per_second = 1

func _ready():
	super()
	anim_name = "attack1"

func enter_state():
	super()
	anim.play(anim_name)
	unit.velocity = Vector2.ZERO
	time = 0.0
	harm_ended = false
	harm_started = false
	casted = false

func exit_state():
	pass

func loop_physics_process(delta):
	unit.velocity = Vector2.ZERO
	
	if time > harm_start and !harm_started:
		harm_started = true
		for beam in unit.beams.get_children():
			beam.harm = true
			beam.set_line_width(16)
	
	if time > harm_stop and !harm_ended:
		harm_ended = true
		for beam in unit.beams.get_children():
			beam.harm = false
	
	if harm_ended:
		for beam in unit.beams.get_children():
			beam.set_line_width(beam.width - delta * 8)
	
	
	
	if anim.frame == 8 and !casted:
		casted = true
		unit.anim_paused = true
		anim.pause()
		var i = 0
		unit.beams.position = unit.staff_position.position
		for beam in unit.beams.get_children():
			beam.set_line_width(1)
			beam.rotation = beam_ang + (1.5708 * i)
			beam.activate()
			i += 1
	
	if casted and time < timeout:
		beam_ang += delta * beam_rotations_per_second
		var i = 0
		unit.beams.position = unit.staff_position.position
		for beam in unit.beams.get_children():
			beam.rotation = beam_ang + (1.5708 * i)
			i += 1
		
		time += delta
		if time >= timeout:
			anim.play()
			unit.anim_paused = false
			for beam in unit.beams.get_children():
				beam.deactivate()
	
	
	if anim.frame == 12:
		var next_states = ["chase", "run"]
		var random_index = randi() % next_states.size()
		statemachine.set_state(next_states[random_index])

func loop_process(delta):
	pass
