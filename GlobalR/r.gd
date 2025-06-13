extends Node

signal death
signal levelup

@onready var user : User = $User

@export var current_Scene : String = "res://Scenes/game_scene.tscn"

const Scenes = [
	preload("res://Scenes/game_scene.tscn")
]

const ScenePort = {
	'GameScene' : 8887,
	'DungeonScene' : 8886
}

var ServerIP : String = '127.0.0.1'
var ServerPort : int = 8888
var UserName : String = 'Test'

var player_spawn_position: Vector2
# Called when the node enters the scene tree for the first time.

var player_hp: int = 3 #玩家的血量

var opened_chests: Array[String] = []

func _ready() -> void:
	load_config()




## 保存存档数据
func save_profile():
	
	var profile = SaveProfile.new()
	profile.hp = user.hp
	profile.mp = user.mp
	profile.exp = user.exp
	profile.MAX_hp = user.MAX_hp
	profile.MAX_mp = user.MAX_mp
	profile.MAX_exp = user.MAX_exp
	profile.items = user.items

	
	ResourceSaver.save(profile, "user://save.tres")
	print('Saved!')

## 保存配置数据
func save_config():
	var profile = ConfigProfile.new()
	profile.ServerIP = ServerIP
	profile.UserName = UserName
	profile.current_Scene = current_Scene
	ResourceSaver.save(profile, "user://config.tres")
	print('Saved!')
	
# 加载
func load_profile():
	if not ResourceLoader.exists("user://save.tres"):
		return
	var profile = ResourceLoader.load("user://save.tres") as SaveProfile
	user.hp = profile.hp
	user.mp = profile.mp
	user.exp = profile.exp
	user.MAX_hp = profile.MAX_hp
	user.MAX_mp = profile.MAX_mp
	user.MAX_exp = profile.MAX_exp
	user.items = profile.items

func load_config():
	if not ResourceLoader.exists("user://config.tres"):
		return
	var profile = ResourceLoader.load("user://config.tres") as ConfigProfile
	current_Scene = profile.current_Scene
	ServerIP = profile.ServerIP
	UserName = profile.UserName
	
	print('Loaded!')


# 规范 hp
func _regulate_hp():
	if user.hp <= 0:
		user.hp = 0
		emit_signal("death")
	if user.hp > user.MAX_hp:
		user.hp = user.MAX_hp

func set_health(value : int):
	user.hp = value
	_regulate_hp()

# 添加或者减少 hp
func modify_health(value : int):
	user.hp += value
	_regulate_hp()

func _regulate_mp():
	if user.mp <= 0:
		user.mp = 0
	if user.mp > user.MAX_mp:
		user.mp = user.MAX_mp

func set_mana(value : int):
	user.mp = value
	_regulate_mp()

# 添加或者减少 mp
func modify_mana(value : int):
	user.mp += value
	_regulate_mp()

func _regulate_exp():
	if user.exp <= 0:
		user.exp = 0
	if user.exp >= user.MAX_exp:
		emit_signal("levelup")
		user.exp = 0

func set_exp(value : int):
	user.exp = value
	_regulate_exp()

# 添加或者减少 exp
func modify_exp(value : int):
	user.exp += value
	_regulate_exp()

func getSceneName(path : String) -> String:
	return path.get_file().get_basename()
