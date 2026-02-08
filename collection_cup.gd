extends StaticBody2D

@onready var cup_contents_detection: Area2D = $CupContentsDetection

var contents: Array[Node2D] = []


func _on_cup_contents_detection_body_entered(body: Node2D) -> void:
	print(body.name)
	contents.append(body)
