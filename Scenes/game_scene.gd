extends Node2D
@onready var players: Node = $Players
@onready var enemys: Node = $Enemys

const PLAYER = preload("res://Character/Players/Onlineplayer.tscn")
const ENEMY = preload("res://Enemies/slime_enemy.tscn")
@export var enemy_spawn = [Vector2(25,-25), Vector2(-132,66), Vector2(-48,74), Vector2(75, -133)]

var peer = ENetMultiplayerPeer.new()

@export var thisName : String ## 这个的名字 (一般驼峰即可)
@export var defaultPos : Vector2
var pos = {}	## 记录名字对应的坐标
var id2name = {}	## 记录id对应的名字

func _ready() -> void:
	Music.stop()
	if OS.has_feature("dedicated_server"):
		print(name, '创建完毕')
		pass
	else:
		joinServer()
	
	
#func syncPos():
	#for child in players.get_children():
		#pos[child.name] = child.position

func createServer():
	var err = peer.create_server(R.ScenePort[thisName])
	if err != OK:
		printerr('服务器创建失败', err)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connect)
	multiplayer.peer_disconnected.connect(_on_peer_disconnect)

# 添加一个玩家
func add_player(id : int):
	var player = PLAYER.instantiate()
	player.name = str(id)
	player.position = pos.get(id2name.get(id,'Unamed'), defaultPos)
	players.add_child(player)


# 删除一个玩家dsadwasd
func del_player(id : int):
	var player = players.get_node(str(id))
	print('正在删除 ', player)
	pos[id2name.get(id,'Unamed')] = player.position
	player.queue_free()

@rpc("any_peer","reliable",'call_remote')
func spawn_enemy():
	for child in enemys.get_children():
		child.die()
	var cnt = 0
	for vec in enemy_spawn:
		var enemy = ENEMY.instantiate()
		enemy.position = vec
		enemy.name = str(cnt)
		cnt += 1
		enemys.add_child(enemy)
	
# 当有客户端连入的时候
func _on_peer_connect(id : int):
	print('玩家连接 ID: ', id)
	add_player(id)

# 当有客户端连入的时候
func _on_peer_disconnect(id : int):
	print('玩家断开连接 ID: ', id)
	del_player(id)
	
	
## 创建客户端并与服务端连接
func joinServer():
	peer.create_client(R.ServerIP, R.ScenePort[thisName])
	multiplayer.multiplayer_peer = peer

	rpc('setName', R.name, peer.get_unique_id())

@rpc("any_peer","reliable",'call_remote')
func setName(name : String, id : int):
	id2name[id] = name


## 开关开的时候生成怪物
func _on_switch_switch_activated() -> void:
	rpc_id(1,'spawn_enemy')
