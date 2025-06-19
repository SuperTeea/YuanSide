extends Marker2D

@export var target_score: int
var score: int = 0

signal puzzle_solved
signal puzzle_failed

func increase_score():
	puzzle_solved.emit()


func decrease_score():
	puzzle_failed.emit()

		#
#func refresh():
	#if score >= target_score:
		#print('emitted solved')
		#
	#if score < target_score:
		#print('emitted unsolved')
		#
