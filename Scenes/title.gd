extends Control

@onready var r = R

var singlePlayer : bool = true

func _ready() -> void:
	await get_tree().root.ready  # 等待父节点就绪
	$ServerSettings/ServerIP.text = R.ServerIP
	$ServerSettings/UserName.text = R.UserName
	$HTTPRequest.request_completed.connect(_on_request_completed)
	
	if OS.has_feature("dedicated_server"):
		print('I am server.')
		var root = get_tree().root
		for scene in R.Scenes:
			var sc = scene.instantiate()
			sc.name = 'GameScene'
			root.add_child(sc)
			sc.createServer()
		#get_tree().change_scene_to_file.call_deferred(R.current_Scene)
		print('服务器启动完成！')
		queue_free.call_deferred()
## 开始游戏(读取存档并开始)
func _on_start_pressed() -> void:
	if singlePlayer:
		get_tree().change_scene_to_file.call_deferred("res://AlexMashiro/map/map_1.tscn")
	else:
		get_tree().change_scene_to_file.call_deferred("res://Scenes/game_scene.tscn")
		
	#get_tree().change_scene_to_file.call_deferred("res://Scenes/DungeonScene/dungeon_scene.tscn")

## 同步存档(通过服务器)
func _on_sync_pressed() -> void:
	$HTTPRequest.request('http://10.10.65.38:5000/')

func _on_request_completed(result, response_code, headers, body):
	$ServerInfo.text = body.get_string_from_utf8()

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


func _on_check_button_toggled(toggled_on: bool) -> void:
	singlePlayer = !toggled_on
	print('当前 singlePlayer ', singlePlayer)
