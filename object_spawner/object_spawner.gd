extends Node2D

@export var coffee_bean: PackedScene
@export var water: PackedScene
@export var germ: PackedScene

@onready var object_container: Node = $ObjectContainer
var objects = []

enum spawn_type {WATER, COFFEE, GERM}

var curr_type: spawn_type = spawn_type.WATER

func _input(event: InputEvent) -> void:
	# handle keyboard input
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_1:
			curr_type = spawn_type.WATER
			print("\nSwitched to water")
		if event.keycode == KEY_2:
			curr_type = spawn_type.COFFEE
			print("\nSwitched to coffee")
		if event.keycode == KEY_3:
			curr_type = spawn_type.GERM
			print("\nSwitched to germ")
		if event.keycode == KEY_R:
			print("\nRemoved ", objects.size(), " objects")
			for obj in objects:
				if is_instance_valid(obj):
					obj.queue_free()
			objects.clear()
			i = 0
			j = 0
			k = 0
			
			
	# handle mouse input
	if event is InputEventMouseButton:
		if event.pressed:
			spawn_object(curr_type)
			
var i := 0
var j := 0
var k := 0
func spawn_object(type: spawn_type) -> void: 
	# just spawn where mouse clicks for now
	var mouse_pos = get_global_mouse_position()
	
	var instance: Node2D
	match type:
		spawn_type.WATER:
			instance = water.instantiate()
			instance.name = "Water%d" %i
			i += 1
		spawn_type.COFFEE:
			instance = coffee_bean.instantiate()
			instance.name = "Coffee%d" %j
			j += 1
		spawn_type.GERM:
			instance = germ.instantiate()
			instance.name = "Germ%d" %k
			k += 1
	
	instance.global_position = mouse_pos
	instance.get_child(0).scale *= .25
	instance.get_child(1).scale *= .25
	
	objects.append(instance)
	object_container.add_child(instance)
	
	

	
