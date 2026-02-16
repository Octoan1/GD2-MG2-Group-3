extends StaticBody2D

signal score_changed(amount: int, destroy_location: Vector2, ingredients: Array)

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
	check_recipe(base_recipe)

func check_recipe(recipe: Recipe) -> void:
	match recipe:
		Recipe.COFFEE:
			var coffee: IngredientObject = null
			var water: IngredientObject = null
			for ingredient: IngredientObject in cup_contents_detection.get_overlapping_bodies():
				if ingredient.is_in_group("coffee") and coffee == null:
					#ingredient.modulate = Color.GOLD
					coffee = ingredient
				elif ingredient.is_in_group("water") and water == null:
					#ingredient.modulate = Color.GOLD
					water = ingredient
				elif ingredient.is_in_group("germ"):
					update_score(-3, ingredient)
				if coffee and water:
					var value = 0
					
					value += coffee.value * 2 if coffee.has_been_in_cup else coffee.value
					value += water.value * 2 if water.has_been_in_cup else water.value
					
					update_score(value, coffee, water)
					coffee = null
					water = null
				else: 
					if ingredient: 
						ingredient.apply_impulse(Vector2(0,0))
					
		Recipe.TRASH:
			for ingredient: IngredientObject in cup_contents_detection.get_overlapping_bodies():
				if ingredient.is_in_group("germ"):
					#ingredient.modulate = Color.RED
					var value = ingredient.value * 2 if not ingredient.has_been_in_cup else ingredient.value
					update_score(value, ingredient)
				else:
					update_score(-1, ingredient)

func update_score(amount: int, ... ingredients: Array) -> void:
	for ingredient in ingredients:
		ingredient.queue_free()
	score_changed.emit(amount, ingredients[0].position, ingredients)

func _on_remove_all_ingredients() -> void:
	contents.clear()
