extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# conditions based on score
	# really noob text
	if score_board.player_score < 0:
		self.text = "You're not very good at this, are you?"
	elif score_board.player_score < score_board.win_score / 2:
		self.text = "You can do better than that!"
	elif score_board.player_score < score_board.win_score:
		self.text = "Close one! You just need %d more points!" % (score_board.win_score - score_board.player_score)
	else:
		self.text = "You are the champion coffee maker!"
	
	self.text += "\nScore: %d / %d" %  [score_board.player_score, score_board.win_score] 
