extends Resource
class_name Wave

@export var ingredients: Array[Ingredient.Type]
@export_range(0, 5) var delay_between: float
@export_range(0, 10) var delay_next_wave: float
