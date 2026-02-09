extends Label

var score: int = 0

func _ready() -> void:
	self.text = "Score: %d" %score

func _on_victory_cup_update_score(amount: int) -> void:
	score += amount
	self.text = "Score: %d" %score

func _on_trash_cup_update_score(amount: int) -> void:
	score += amount
	self.text = "Score: %d" %score
