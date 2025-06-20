extends Node

#const defaultIP : String = '0.0.0.0'
const defaultPort : int = 8889
const MAX_CLIENTS = 10

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

var Chat


func _ready() -> void:
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	if OS.has_feature("dedicated_server"):
		print('I am chat server.')
		var peer = ENetMultiplayerPeer.new()
		peer.create_server(defaultPort, MAX_CLIENTS)
		multiplayer.multiplayer_peer = peer
		print(peer.get_unique_id())
		
		
	else:
		print('I am chat client.')
		await get_tree().create_timer(0.5).timeout
		var peer = ENetMultiplayerPeer.new()
		var ret = peer.create_client(R.ServerIP, defaultPort)
		multiplayer.multiplayer_peer = peer
		print(ret)
		print(R.ServerIP, R.ServerPort)
		print(peer.get_unique_id())

@rpc('reliable')
func sync_message(user, message):
	Chat._add_message(user, message)

@rpc("any_peer","reliable")
func recv_message(user, message):
	rpc('sync_message',user,message)

func send_message(user, message):
	rpc_id(1, 'recv_message', user, message)

func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null

# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	print('Chat玩家连入', id)
	if multiplayer.get_unique_id() == id:
		send_message(R.UserName, '[color=green]加入了游戏[/color]')


func _on_player_disconnected(id):
	print('Chat玩家连出', id)
	#if multiplayer.get_unique_id() == id:
	if multiplayer.get_unique_id() == id:
		send_message(R.UserName, '[color=green]退出了游戏[/color]')

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	server_disconnected.emit()
