extends StaticBody2D

signal update_score(amount: int)
signal collect(amount: int, destroy_location: Vector2)

@onready var cup_contents_detection: Area2D = $CupContentsDetection

@export var spawner: Node2D
@export var base_recipe: Recipe

var contents: Array[Node2D] = []

enum Recipe {COFFEE, TRASH}

func _ready() -> void:
	if spawner:
		spawner.remove_all_ingredients.connect(_on_remove_all_ingredients)

func _on_cup_contents_detection_body_entered(body: Node2D) -> void:
	contents.append(body)
	
	# check for recipe
	check_recipe(base_recipe)
	
	
func check_recipe(recipe: Recipe):
	#print("\nIn ", self.name, ": ")
	#for obj in contents:
		#print(obj.name, " ", obj.get_groups())
	
	# check for recipe
	match recipe:
		Recipe.COFFEE:
			var coffee = null
			var water = null
			for ingredient: RigidBody2D in cup_contents_detection.get_overlapping_bodies():
				if ingredient.is_in_group("coffee") and coffee == null:
					#ingredient.modulate = Color.GOLD
					coffee = ingredient
				elif ingredient.is_in_group("water") and water == null:
					#ingredient.modulate = Color.GOLD
					water = ingredient
				elif ingredient.is_in_group("germ"):
					ingredient.queue_free()
					update_score.emit(-1)
					collect.emit(-3, ingredient.position)
				if coffee and water:
					coffee.queue_free()
					coffee = null
					
					water.queue_free()
					water = null
					
					update_score.emit(3)
					collect.emit(3, ingredient.position)
					
				else: 
					if ingredient: 
						ingredient.apply_impulse(Vector2(0,0))
					
		Recipe.TRASH:
			for ingredient in cup_contents_detection.get_overlapping_bodies():
				if ingredient.is_in_group("germ"):
					#ingredient.modulate = Color.RED
					ingredient.queue_free()
					update_score.emit(1)
					collect.emit(1, ingredient.position)
				else:
					ingredient.queue_free()
					update_score.emit(-1)
					collect.emit(-1, ingredient.position)

		
func _on_remove_all_ingredients() -> void:
	contents.clear()
	
