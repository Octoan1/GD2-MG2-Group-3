extends Node2D
class_name ConfirmAction

signal on_long_press
signal on_long_release

@export var hold_threshold: float
var hold_time: float
var hold_triggered: bool

# require the player to press and hold for something to occur
func _process(delta: float):
	if Input.is_action_pressed("action"): # Replace with your action name
		hold_time += delta
		
		# Check if we've passed the threshold and haven't triggered yet
		if hold_time >= hold_threshold and not hold_triggered:
			_on_long_press_triggered()
			hold_triggered = true
	else:
		# Reset everything when the button is released
		if hold_triggered:
			_on_long_press_released()
			
		hold_time = 0.0
		hold_triggered = false
		
func _on_long_press_triggered():
	on_long_press.emit()
	pass
	
func _on_long_press_released():
	on_long_release.emit()
	pass

func get_pressed_amount() -> float:
	return clamp(hold_time / hold_threshold, 0, 1)
