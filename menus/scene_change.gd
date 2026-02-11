extends Node2D

class_name SceneChange

@export var scene_change: String
@export var delay_click: float

var time: float

func _ready() -> void:
	time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if Input.is_action_just_pressed("action") and time >= delay_click:
		get_tree().change_scene_to_file("res://menus/"+scene_change+".tscn")
