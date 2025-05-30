extends Marker2D

@export var target_score: int
var score: int = 0

signal puzzle_solved
signal puzzle_failed

func increase_score():
	score += 1
	print(score)
	
	if score >= target_score:
		puzzle_solved.emit()

func decrease_score():
	score -= 1
	print(score)
	
	if score < target_score:
		puzzle_failed.emit()
