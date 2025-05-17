extends Node
class_name  MusicSwitcher

## 自动切换音乐的节点
## 可以放在地图场景下
@export var music : AudioStream

func _ready() -> void:
	Music.switch(music)
