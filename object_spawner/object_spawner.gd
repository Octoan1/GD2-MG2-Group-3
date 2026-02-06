extends Node2D

@export var coffee_bean: PackedScene
@export var water: PackedScene
@export var germ: PackedScene

@onready var object_container: Node = $ObjectContainer

enum spawn_type {WATER, COFFEE, GERM}

var curr_type: spawn_type = spawn_type.WATER

# shouldn't be needed
#func _ready() -> void:
	#pass 

# not needed atm
#func _process(delta: float) -> void:
	#pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_1:
			curr_type = spawn_type.WATER
			print("switched to water")
		if event.keycode == KEY_2:
			curr_type = spawn_type.COFFEE
			print("switched to coffee")
		if event.keycode == KEY_3:
			curr_type = spawn_type.GERM
			print("switched to germ")
		else:
			pass
		
	if event is InputEventMouseButton:
		if event.pressed:
			spawn_object(curr_type)
			
			
func spawn_object(type: spawn_type) -> void: 
	# spawn where mouse clicks for now
	var mouse_pos = get_global_mouse_position()
	
	var instance: Node2D
	match type:
		spawn_type.WATER:
			instance = water.instantiate()
		spawn_type.COFFEE:
			instance = coffee_bean.instantiate()
		spawn_type.GERM:
			instance = germ.instantiate()
	
	instance.global_position = mouse_pos
	object_container.add_child(instance)
	
	

	
