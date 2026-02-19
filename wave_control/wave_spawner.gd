extends Node2D

signal level_start(index: int)
signal level_complete(passed: bool)
signal waves_complete
signal levels_complete
signal wave_start(wave_index: int)
signal wave_end(wave_end_delay: float, last_wave: bool)

@export var start_delay: float
@export var end_delay: float
@export var object_spawner: ObjectSpawner
@export var levels: Array[Level]
@export var spawn_pos_marker: Marker2D
@export var below_marker: Marker2D
var spawn_pos: Vector2 # made it originate as Market2D so its more visible in inspector 
@export var curr_wave_label: Label
@export var score_label: Node

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
	if not running_level:
		level_start.emit(level_index)
		score_board.win_score = current_level().score
		score_board.player_score = 0
		running_level = true
		curr_wave_label.visible = true
		score_label.visible = true

# Finish the level before all the waves are to run out
func finish_level():
	print("Finish level invoked")
	var passed = score_board.player_score >= score_board.win_score
	if passed:
		level_index += 1
	
	level_complete.emit(passed)
	
	running_level = false
	curr_wave_label.visible = false
	score_label.visible = false
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
	object_spawner.remove_all_ingredients()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_wave_data()
	spawn_pos = spawn_pos_marker.global_position
	waves_complete.connect(finish_level)
	curr_wave_label.visible = false
	score_label.visible = false
	curr_wave_label.text = wave_to_string()

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
			var last_wave = wave_index >= current_waves().size() - 1
			if not sent_wave_end:
				wave_end.emit(current_wave().delay_next_wave, last_wave)
				sent_wave_end = true
			
			if last_wave and not all_ingredients_below(): 
				prev_spawn_time = time
				spawn_delta = -1
			# wait time OR if it is the last wave wait until all ingredients are below a certain point

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
	
	
func wave_to_string() -> String:
	var test: String = ""
	for i in range(ingredient_index, current_wave().ingredients.size()):
		
		var ingredient = current_wave().ingredients[i]
		
		match ingredient:
			Ingredient.Type.WATER:
				test += "Water\n"
			Ingredient.Type.COFFEE_BEAN:
				test += "Coffee Bean\n"
			Ingredient.Type.GERM:
				test += "Germ\n"

	
	return test

func spawn_ingredient_random_position(ingredient: Ingredient.Type):
	# print("Spawn?")
	object_spawner.spawn_object(ingredient, spawn_pos)
	prev_spawn_time = time
	ingredient_index += 1
	curr_wave_label.text = wave_to_string()
	
func all_ingredients_below() -> bool:
	for child in object_spawner.object_container.get_children():
		if child.position.y < below_marker.global_position.y:
			return false
	
	return true
	
# helper stuff
func current_wave() -> Wave:
	return current_waves()[wave_index]
	
func current_waves() -> Array[Wave]:
	return current_level().waves
	
func current_level() -> Level:
	return levels[level_index]
