extends HSlider

@export var confirm: ConfirmAction

func _process(_delta: float) -> void:
	value = confirm.get_pressed_amount()
