extends Node2D

class_name SceneChange

@export var scene_change: String
@export var delay_click: float

var time: float

func _ready() -> void:
	time = 0

func go_to_game() -> void:
	get_tree().change_scene_to_file("res://menus/"+scene_change+".tscn")
