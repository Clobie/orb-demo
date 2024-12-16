extends RigidBody2D

@export var hp = 51
@onready var hp_max = hp

@export var button_text = ""
@export var scene_path = ""

@export var function = ""

var disabled = false

func _ready():
	$ProgressBar.max_value = hp_max
	$ProgressBar.min_value = 0
	$ProgressBar.value = hp_max
	$Label.text = button_text
	
func _process(_delta):
	pass

func take_damage(amount, _parent):
	if amount > 0:
		hp = clamp(hp - amount, 0, hp_max)
		$ProgressBar.value = hp
	if hp <= 0:
		#if function == "host":
		#	NetworkManager.create_server()
		#elif function == "join":
		#	NetworkManager.connect_to_server()
		if scene_path != "":
			SceneManager.fade_to_scene(scene_path)
			call_deferred("queue_free")
		
func hit(_obj, gpos, dir):
	var lpos = global_position - gpos
	apply_impulse(dir * 200, -lpos)
	
