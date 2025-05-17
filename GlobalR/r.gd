extends Node

signal death
signal levelup

@onready var user : User = $User
@onready var items = $items

@export var current_Scene : String = "res://Scenes/Basement.tscn"

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
