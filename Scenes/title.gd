extends Control

@onready var r = R

func _ready() -> void:
	$ServerSettings/ServerIP.text = R.ServerIP
	$ServerSettings/UserName.text = R.UserName

## 开始游戏(读取存档并开始)
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred(R.current_Scene)

## 同步存档(通过服务器)
func _on_sync_pressed() -> void:
	pass # Replace with function body.

## 退出游戏
func _on_exit_pressed() -> void:
	get_tree().quit()

## 当修改了ServerIP
func _on_server_ip_text_changed(new_text: String) -> void:
	R.ServerIP = new_text
	R.save_config()

## 当修改了UserName
func _on_user_name_text_changed(new_text: String) -> void:
	R.UserName = new_text
	R.save_config()
