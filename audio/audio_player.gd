extends AudioStreamPlayer2D

@export var default_track: AudioStream
@export var intense_track: AudioStream
@export var score_threshold: float
var intensity: bool
var score: float

func _input(event: InputEvent) -> void:
	
	# flip intensity of song on pressing "I"
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_I:
		intensity = not intensity
		update_track()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_track()

# Play the default track
func update_track():
	if (intensity):
		stream = intense_track
	else:
		stream = default_track
	play()
	
# When score gets above amount change intensity
func _on_update_score(amount: int) -> void:
	score += amount
	
	if (intensity == not true and score > score_threshold):
		intensity = true
		update_track()
