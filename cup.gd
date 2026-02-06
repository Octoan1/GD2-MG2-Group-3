extends Node2D

@export var rotation_speed : float
@export var push_amount : float
@export var speed_percent : float

var max_angle = 120

var prev_rotate = null
var velocity = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_no_velocity(delta)
	
	
func rotate_no_velocity(delta: float):	
	if(Input.is_action_pressed("Action")):
		rotation += -rotation_speed * delta
	else:
		rotation += rotation_speed * delta


func rotate_velocity(delta: float):
	if (prev_rotate == null):
		prev_rotate = rotation
	
	if (velocity == null):
		velocity = 0;
	
	if(Input.is_action_pressed("Action")):
		velocity = -push_amount * speed_percent / 100
		pass
	
	else:
		rotation += delta * rotation_speed # * velocity * speed_percent / 100

	velocity += delta * speed_percent / 100
	
	print(velocity)
	
	if(Input.is_action_pressed("Action")):
		velocity = -push_amount * speed_percent / 100
		pass
	
	pass
	
	pass
