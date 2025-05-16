extends Node
class_name User

@export var hp : int = 0	# 生命值
@export var mp : int
@export var exp : int = 0
@export var MAX_hp : int = 100
@export var MAX_mp : int
@export var MAX_exp : int = 233

@export var current_level : String	# 当前的关卡

@export var items : Array[String]	# 目前栏内的物品

# 保存
func save_profile():
	var profile = SaveProfile.new()
	profile.hp = hp
	profile.mp = mp
	profile.exp = exp
	profile.MAX_hp = MAX_hp
	profile.MAX_mp = MAX_mp
	profile.MAX_exp = MAX_exp
	profile.current_level = current_level
	profile.items = items
	
	ResourceSaver.save(profile, "user://save.tres")
	print('Saved!')

# 加载
func load_profile():
	var profile = ResourceLoader.load("user://save.tres") as SaveProfile
	hp = profile.hp
	mp = profile.mp
	exp = profile.exp
	MAX_hp = profile.MAX_hp
	MAX_mp = profile.MAX_mp
	MAX_exp = profile.MAX_exp
	current_level = profile.current_level
	items = profile.items
	
	print('Loaded!')
