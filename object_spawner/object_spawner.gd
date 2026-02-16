extends Node2D
class_name ObjectSpawner

signal remove_all_ingredients

@export var coffee_bean: PackedScene
@export var water: PackedScene
@export var germ: PackedScene
@export var debug_mode: bool

@onready var debug_label: Label = $"../DebugLabel"
@onready var object_container: Node = $ObjectContainer
var objects = []

var curr_type: Ingredient.Type = Ingredient.Type.WATER

func _ready() -> void:
	debug_label.visible = debug_mode

func _process(_delta: float) -> void:
	debug_label.visible = debug_mode
	
func _input(event: InputEvent) -> void:
	if not debug_mode:
		return
	# handle keyboard input
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_1:
			curr_type = Ingredient.Type.WATER
			print("Switched to water")
			debug_label.text = "Selected Ingredient: Water"
		if event.keycode == KEY_2:
			curr_type = Ingredient.Type.COFFEE_BEAN
			print("Switched to coffee")
			debug_label.text = "Selected Ingredient: Coffee"
		if event.keycode == KEY_3:
			curr_type = Ingredient.Type.GERM
			print("Switched to germ")
			debug_label.text = "Selected Ingredient: Germ"
		if event.keycode == KEY_R:
			print("\nRemoved ", objects.size(), " objects")
			for obj in objects:
				if is_instance_valid(obj):
					obj.queue_free()
			objects.clear()
			i = 0
			j = 0
			k = 0
			remove_all_ingredients.emit()
		#if event.keycode == KEY_T:
			#for obj in objects:
				#print(obj)
			
			
			
	# handle mouse input
	if event is InputEventMouseButton:
		if event.pressed:
			spawn_object(curr_type, get_global_mouse_position())
			
var i := 0
var j := 0
var k := 0
func spawn_object(type: Ingredient.Type, spawn_position: Vector2) -> void: 
	
	var instance: Node2D
	match type:
		Ingredient.Type.WATER:
			instance = water.instantiate()
			instance.name = "Water%d" %i
			#instance.add_to_group("water")
			i += 1
		Ingredient.Type.COFFEE_BEAN:
			instance = coffee_bean.instantiate()
			instance.name = "Coffee%d" %j
			j += 1
		Ingredient.Type.GERM:
			instance = germ.instantiate()
			instance.name = "Germ%d" %k
			k += 1
	
	instance.global_position = spawn_position
	if type == Ingredient.Type.GERM:
		instance.get_child(0).scale *= 1
		instance.get_child(1).scale *= 1
	else:
		instance.get_child(0).scale *= .25
		instance.get_child(1).scale *= 0.25

		
	
	objects.append(instance)
	object_container.add_child(instance)
