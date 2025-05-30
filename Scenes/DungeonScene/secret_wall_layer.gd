extends TileMapLayer

#这个函数用来显示秘密房间
func enable_secret_wall():
	visible = true
	#启用碰撞
	collision_enabled = true

#这个函数用来显示秘密房间
func disable_secret_wall():
	visible = false
	#禁用碰撞
	collision_enabled = false

#连接该开关信号到秘密房间的代码中，可以不用下面的方法，直接选取连接
#func _on_switch_switch_activated() -> void:
	#enable_secret_wall()


#func _on_switch_switch_deactivated() -> void:
	#disable_secret_wall()
