extends Node

signal win_score_changed(int)
signal player_score_changed(int)

var win_score: int = 50
var player_score: int = 0

var prev_win_score: int = win_score - 1
var prev_player_score: int = player_score - 1

func _process(_delta: float) -> void:
	if prev_win_score != win_score:
		win_score_changed.emit()
		prev_win_score = win_score
		
	if prev_player_score != player_score:
		player_score_changed.emit()
		prev_player_score = win_score
