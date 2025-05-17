extends Control

## 开始游戏(读取存档并开始)
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred(R.current_Scene)

## 同步存档(通过服务器)
func _on_sync_pressed() -> void:
	pass # Replace with function body.

## 退出游戏
func _on_exit_pressed() -> void:
	get_tree().quit()
