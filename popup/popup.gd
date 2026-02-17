extends Node2D

@export var point: AudioStreamPlayer2D
@export var lose: AudioStreamPlayer2D
@export var next_wave: AudioStreamPlayer2D
@export var wave_start: AudioStreamPlayer2D
@export var point_text: Array[String]
@export var lose_text: Array[String]

# Unused
#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		if event.pressed:
#			_on_update_score(randi_range(0, 1), get_local_mouse_position())

func _on_update_score(amount: int, spawn_pos: Vector2, _0) -> void:

	if amount > 0:
		var rand = randi_range(0, point_text.size() - 1)
		var text = point_text[rand]
		
		pulse_label(Color.GREEN, text, spawn_pos)
		
		point.pitch_scale = randf_range(0.9, 1.1)
		point.play()
	else:
		var rand = randi_range(0, lose_text.size() - 1)
		var text = lose_text[rand]
		
		pulse_label(Color.RED, text, spawn_pos)
		
		lose.pitch_scale = randf_range(0.9, 1.1)
		lose.play()

func pulse_label(color: Color, text: String, spawn_pos: Vector2, duration: float = 0.5):
	# Create label
	var label = Label.new()
	add_child(label)
	
	# Set
	label.add_theme_color_override("font_color", color)
	label.text = text
	label.reset_size()
	label.scale = Vector2(6, 6)
	var half_size = label.size / 2
	label.pivot_offset = half_size
	var rand_rotate = randf_range(-5, 5)
	label.rotation_degrees = rand_rotate
	label.position = spawn_pos - half_size
	label.z_index = 100
	
	# Start tweening
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label, "scale", Vector2(1, 1), duration)
	tween.parallel().tween_property(label, "rotation_degrees", rand_rotate * -2, duration)
	tween.parallel().tween_property(label, "modulate:a", 0, duration)
	tween.finished.connect(label.queue_free)



func _on_wave_end(wave_end_delay: float, last_wave: bool) -> void:
	next_wave.play()
	if not last_wave:
		pulse_label(Color.WHITE, "New wave in %d seconds" % wave_end_delay, Vector2(0, -300), wave_end_delay)
	else:
		pulse_label(Color.WHITE, "All waves complete!", Vector2(0, -300), wave_end_delay)

func _on_wave_start(wave_index: int) -> void:
	wave_start.play()
	pulse_label(Color.WHITE, "Wave %d" % (wave_index + 1), Vector2(0, -300), 2)
	
func _on_level_complete(passed:bool) -> void:
	if passed:
		pulse_label(Color.GREEN, "Level complete!", Vector2(0, -300), 2)
	else:
		pulse_label(Color.RED, "You failed!", Vector2(0, -300), 2)


func _on_level_start(index: int) -> void:
	pulse_label(Color.WHITE, "Level %d" % (index + 1), Vector2(0, -300), 2)
