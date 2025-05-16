extends Control

func _enter_tree() -> void:
	Music.switch("res://Assets/Musics/Main_Theme.ogg")

# 开始游戏(读取存档并开始)
func _on_start_pressed() -> void:
	pass # Replace with function body.

# 同步存档(通过服务器)
func _on_sync_pressed() -> void:
	pass # Replace with function body.

# 退出游戏
func _on_exit_pressed() -> void:
	get_tree().quit()
