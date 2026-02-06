extends Node2D

@export var coffee_bean : PackedScene

@onready var object_container: Node = $ObjectContainer

enum spawn_type {COFFEE_BEAN, TEA, GERM}

# shouldn't be needed
#func _ready() -> void:
	#pass 

# pass for now
#func _process(delta: float) -> void:
	#pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			spawn_object(spawn_type.COFFEE_BEAN)
			
			
func spawn_object(_type: spawn_type) -> void: 
	for i in range(1):
		# spawn where mouse clicks for now
		var mouse_pos = get_global_mouse_position()
		
		var bean: Node2D = coffee_bean.instantiate()
		bean.global_position = mouse_pos
		object_container.add_child(bean)
	
