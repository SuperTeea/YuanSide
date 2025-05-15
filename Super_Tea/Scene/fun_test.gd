extends Node2D

func _ready() -> void:
	Music.setCycle(Music.NO_CYCLE)
	Music.switch('res://Musics/Main_Theme.ogg')

func _on_play_pressed() -> void:
	Music.play()
	
func _on_stop_pressed() -> void:
	Music.stop()
