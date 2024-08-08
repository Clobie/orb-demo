extends CanvasLayer

func _ready():
	pass

func _process(delta):
	pass

func start():
	$ColorRect/AnimationPlayer.play("fade_out")
	$ColorRect/AnimationPlayer2.play("rotate")

func end():
	$ColorRect/AnimationPlayer.play("fade_in")
	$ColorRect/AnimationPlayer2.play("rotate")
