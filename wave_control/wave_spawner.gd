extends Node2D

signal waves_complete
signal levels_complete
signal wave_start(wave_index: int)
signal wave_end(wave_end_delay: float)

@export var start_delay: float
@export var spawn_pos: Vector2
@export var level_complete_predicate: Callable
@export var object_spawner: Spawner
@export var levels: Array[Level]

# level details
var level_index: int = 0
var running_level: bool = false

# wave details
var time: float = 0
var prev_spawn_time: float = 0
var wave_index: int = 0
var ingredient_index: int = 0

# signal flags
var sent_waves_complete: bool = false
var sent_wave_start: bool = false
var sent_wave_end: bool = false

func start_level():
	running_level = true

# Finish the level before all the waves are to run out
func finish_level():
	level_index += 1
	running_level = false
	reset_wave_data()
	
	if level_index >= levels.size():
		levels_complete.emit()
	
func reset_wave_data():
	time = -start_delay
	prev_spawn_time = 0
	wave_index = 0
	ingredient_index = 0
	sent_waves_complete = false
	sent_wave_start = false
	sent_wave_end = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_wave_data()
	waves_complete.connect(finish_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not running_level:
		return
	
	# print("Status ", int(time), " Wave Index ", wave_index, " Ingredient Index ", ingredient_index, " Wave Count ", waves.size())
	var spawn_delta = time - prev_spawn_time
	time += delta
	
	if (time < 0):
		return
	
	# more waves?
	if wave_index < current_waves().size():
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
		print("no more waves")
		if not sent_waves_complete:
			sent_waves_complete = true
			waves_complete.emit()
			print("Waves complete!")

func spawn_ingredient_random_position(ingredient: Ingredient.Type):
	# print("Spawn?")
	object_spawner.spawn_object(ingredient, spawn_pos)
	prev_spawn_time = time
	ingredient_index += 1
	
# helper stuff
func current_wave() -> Wave:
	return current_waves()[wave_index]
	
func current_waves() -> Array[Wave]:
	return levels[level_index].waves
