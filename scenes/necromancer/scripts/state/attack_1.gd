extends State_CharacterBody2D


# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name

var casted = false

func _ready():
	super()
	anim_name = "attack1"

func enter_state():
	super()
	anim.play(anim_name)
	unit.velocity = Vector2.ZERO
	casted = false
	unit.audio_stream_player_2d_laugh_1.play()
	
func exit_state():
	pass

func loop_physics_process(delta):
	if anim.frame == 6 and !casted:
		casted = true
		var floorpos = unit.floor_pos_below_target()
		if floorpos:
			var att = unit.GROUND_EXPLOSION.instantiate()
			att.global_position = floorpos
			get_tree().root.add_child(att)
				
	if anim.frame == 12:
		var next_states = ["chase", "run"]
		var random_index = randi() % next_states.size()
		statemachine.set_state(next_states[random_index])

func loop_process(delta):
	pass
