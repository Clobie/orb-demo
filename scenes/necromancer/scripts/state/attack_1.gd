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
	
func exit_state():
	pass

func loop_physics_process(delta):
	if anim.frame == 6 and !casted:
		casted = true
		if unit.target.is_on_floor():
			var att = unit.GROUND_EXPLOSION.instantiate()
			att.global_position = unit.target.global_position
			get_tree().root.add_child(att)
		else:
			var angle_increment = 360.0 / 12.0
			for i in range(12):
				var att = unit.FIREBALL.instantiate()
				att.global_position = unit.staff_position.global_position
				att.dir = Vector2.RIGHT.rotated(i * angle_increment * 0.01745)
				get_tree().root.add_child(att)
				
	if anim.frame == 12:
		var next_states = ["chase", "teleport", "run"]
		var random_index = randi() % next_states.size()
		statemachine.set_state(next_states[random_index])

func loop_process(delta):
	pass
