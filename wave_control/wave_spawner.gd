extends Node2D

signal waves_complete
signal wave_start(wave_index: int)
signal wave_end(wave_end_delay: float)

@export var start_delay: float
@export var spawn_pos_marker: Marker2D
var spawn_pos: Vector2 # made it originate as Market2D so its more visible in inspector 
@export var object_spawner: ObjectSpawner
@export var waves: Array[Wave]

var time: float = 0
var prev_spawn_time: float = 0
var wave_index: int = 0
var ingredient_index: int = 0

# signal flag
var sent_waves_complete: bool = false
var sent_wave_start: bool = false
var sent_wave_end: bool = false

func current_wave() -> Wave:
	return waves[wave_index]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = -start_delay
	spawn_pos = spawn_pos_marker.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# print("Status ", int(time), " Wave Index ", wave_index, " Ingredient Index ", ingredient_index, " Wave Count ", waves.size())
	var spawn_delta = time - prev_spawn_time
	time += delta
	
	if (time < 0):
		return
	
	# more waves?
	if wave_index < waves.size():
		var number_ingredients = current_wave().ingredients.size()
		# spawn first wave instantly
		if ingredient_index == 0:
			if not sent_wave_start:
				wave_start.emit(wave_index)
				sent_wave_start = true
			spawn_ingredient_random_position(current_wave().ingredients[ingredient_index])
		# spawn following ingredients after delay
		elif ingredient_index < number_ingredients: 
			if spawn_delta >= current_wave().delay_between:
				# spawn ingredient
				spawn_ingredient_random_position(current_wave().ingredients[ingredient_index])
		# no more ingredients
		else:
			if not sent_wave_end:
				wave_end.emit(current_wave().delay_next_wave)
				sent_wave_end = true
			if spawn_delta >= current_wave().delay_next_wave:
				prev_spawn_time = time
				ingredient_index = 0
				wave_index += 1
				sent_wave_start = false
				sent_wave_end = false
	else:
		if not sent_waves_complete:
			waves_complete.emit()
			sent_waves_complete = true
			print("Waves complete!")


func spawn_ingredient_random_position(ingredient: Ingredient.Type):
	# print("Spawn?")
	object_spawner.spawn_object(ingredient, spawn_pos)
	prev_spawn_time = time
	ingredient_index += 1
