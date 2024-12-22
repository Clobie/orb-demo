extends State_CharacterBody2D


# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name

var casted = false

func _ready():
	super()
	anim_name = "attack2"

func enter_state():
	super()
	casted = false
	anim.play(anim_name)
	unit.velocity = Vector2.ZERO
	
func exit_state():
	pass

func loop_physics_process(delta):
	if anim.frame == 6 and !casted:
		casted = true
		var dir = (unit.target.global_position - unit.staff_position.global_position).normalized()
		var dirs = []
		dirs.append(dir)
		for i in range(3):
			dirs.append(dir.rotated(i * 12 * 0.01745))
		for i in range(3):
			dirs.append(dir.rotated(-i * 12 * 0.01745))
		
		for i in range(dirs.size()):
			var att = unit.FIREBALL.instantiate()
			att.global_position = unit.staff_position.global_position
			att.dir = dirs[i]
			get_tree().root.add_child(att)
	if anim.frame == 12:
		var next_states = ["chase", "run"]
		var random_index = randi() % next_states.size()
		statemachine.set_state(next_states[random_index])

func loop_process(delta):
	pass
