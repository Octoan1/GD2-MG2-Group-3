extends Node2D
class_name Spawner

func spawn_object(type: Ingredient.Type, spawn_position: Vector2):
	print("Spawning %s, \tat (%d, %d)" % [Ingredient.Type.keys()[type],spawn_position.x, spawn_position.y])
		
