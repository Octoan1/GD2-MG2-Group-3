extends Label

signal score_changed(amount: int, destroy_location: Vector2, ingredients: Array)

func _ready() -> void:
	score_board.player_score = 0
	set_self_text()
	score_board.player_score_changed.connect(set_self_text)
	score_board.win_score_changed.connect(set_self_text)


func _update_score(amount: int, destroy_location: Vector2, ingredients: Array):
	score_board.player_score += amount
	set_self_text()
	score_changed.emit(amount, destroy_location, ingredients)

func end_game():
	get_tree().change_scene_to_file("res://menus/end.tscn")

func _on_levels_complete() -> void:
	end_game()

func set_self_text():
	self.text = "%d / %d" % [score_board.player_score, score_board.win_score ]
