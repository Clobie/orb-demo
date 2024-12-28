extends Node

enum DamageType {
	NORMAL,
	SPELL,
	CRITICAL,
	HEAL,
}

var font = load("res://assets/fonts/PermanentMarker-Regular.ttf")

func create_label(value: int, pos: Vector2, color: String, font_size: int, prefix: String) -> Label:
	var number = Label.new()
	number.global_position = pos
	number.text = prefix + str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	number.label_settings.font = font
	number.label_settings.font_color = color
	number.label_settings.font_size = font_size
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	call_deferred("add_child", number)
	return number

func tween_label(number: Label, y_offset: int, fade_duration: float):
	await number.resized
	number.pivot_offset = number.size / 2.0
	number.position -= number.size / 2.0
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(number, "position:y", number.position.y - y_offset, fade_duration).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "modulate:a", 0.0, fade_duration).set_ease(Tween.EASE_IN)
	await tween.finished
	number.queue_free()

func display_normal(value: int, pos: Vector2):
	var number = create_label(value, pos, "#FFF", 18, "")
	tween_label(number, 50, 0.5)

func display_spell(value: int, pos: Vector2):
	var number = create_label(value, pos, "#FF0", 18, "")
	tween_label(number, 50, 0.5)

func display_critical(value: int, pos: Vector2):
	var number = create_label(value, pos, "#FF0", 28, "")
	tween_label(number, 0, 1.0)

func display_heal(value: int, pos: Vector2):
	var number = create_label(value, pos, "#0F0", 18, "+")
	tween_label(number, 50, 0.5)

func display_number(value: int, pos: Vector2, type: int = DamageType.NORMAL):
	match type:
		DamageType.NORMAL: display_normal(value, pos)
		DamageType.SPELL: display_spell(value, pos)
		DamageType.CRITICAL: display_critical(value, pos)
		DamageType.HEAL: display_heal(value, pos)
