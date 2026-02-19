extends Sprite2D

@export var level_label: Label
@export var wave_spawner: Node2D

var show_level_index = 1
func show_prompt(_passed: bool):
	level_label.text = "Level %d" % (wave_spawner.level_index + 1)
	visible = true	
	
func hide_prompt(_index: int):
	visible = false
