extends StaticBody2D

signal update_score(amount: int)

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
			for ingredient: RigidBody2D in contents:
				if ingredient.is_in_group("coffee") and coffee == null:
					#ingredient.modulate = Color.GOLD
					coffee = ingredient
				elif ingredient.is_in_group("water") and water == null:
					#ingredient.modulate = Color.GOLD
					water = ingredient
				if coffee and water:
					contents.erase(coffee)
					coffee.queue_free()
					coffee = null
					
					contents.erase(water)
					water.queue_free()
					water = null
					
					update_score.emit(3)
				else: 
					if ingredient: 
						ingredient.apply_impulse(Vector2(0,0))
					
		Recipe.TRASH:
			for ingredient in contents:
				if ingredient.is_in_group("germ"):
					#ingredient.modulate = Color.RED
					contents.erase(ingredient)
					ingredient.queue_free()
					
					update_score.emit(1)

		
func _on_remove_all_ingredients() -> void:
	contents.clear()
	
