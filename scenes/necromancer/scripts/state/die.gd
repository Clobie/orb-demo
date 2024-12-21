extends State_CharacterBody2D


# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name

var music = "res://assets/audio/MindsEyePack/8- Quiet.ogg"

func _ready():
	super()
	anim_name = "die"

func enter_state():
	super()
	anim.play(anim_name)
	unit.set_collision_layer_value(2, false)
	AudioManager.fade_to_track(music)
	unit.color_rect.visible = false
	SignalBus.boss_dead.emit()
	for i in range(50):
		var hp = unit.HP_ORB.instantiate()
		hp.global_position = unit.global_position + Vector2(randf_range(-400, 400), randf_range(-400, 400))
		get_tree().root.add_child(hp)
	for i in range(50):
		var en = unit.ENERGY_ORB.instantiate()
		en.global_position = unit.global_position + Vector2(randf_range(-400, 400), randf_range(-400, 400))
		get_tree().root.add_child(en)

func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	pass
