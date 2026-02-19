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
	if Input.is_action_pressed("action"):
		self.rotation += rotation_speed * delta * 1.1 
	else:
		self.rotation += -rotation_speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is IngredientObject:
		var ingredient: IngredientObject = body
		
		match ingredient.type:
			Ingredient.Type.COFFEE_BEAN:
				ingredient.get_node("Sprite2D").texture = load("res://sprites/coffeebean_golden.png")
				$AudioStreamPlayer2D.play()
			Ingredient.Type.WATER:
				ingredient.get_node("Sprite2D").texture = load("res://sprites/water_golden.png")
				$AudioStreamPlayer2D.play()
			Ingredient.Type.GERM:
				pass
				# ingredient.modulate = Color.RED

		ingredient.has_been_in_cup = true
		
