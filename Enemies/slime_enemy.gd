extends CharacterBody2D

var target: Node2D

@export var speed: float = 30
@export var acceleration: float = 5
@export var HP: int = 2

func _physics_process(delta: float) -> void:
	if HP <= 0:
		return
	chase_target()
	
	move_and_slide()
	
	animate_enemy()
	
func animate_enemy():
	var normal_veloctity: Vector2 = velocity.normalized()
	if normal_veloctity.x > 0.707:
		$AnimatedSprite2D.play("move_right")
	elif normal_veloctity.x < -0.707:
		$AnimatedSprite2D.play("move_left")
	elif normal_veloctity.y > 0.707:
		$AnimatedSprite2D.play("move_down")
	elif normal_veloctity.y < -0.707:
		$AnimatedSprite2D.play("move_up")
		
		
	#因为速度方向不可能是纯向一个方向，我们要看他是主要往哪个方向
	
#史莱姆检测到玩家，朝玩家进行移动
func chase_target():
	if target: #如果检测到目标
		var distance_to_player: Vector2 #距离玩家的距离
		#玩家的位置减去史莱姆的位置
		distance_to_player = target.global_position - global_position
		var direction_normal: Vector2 = distance_to_player.normalized() #方向向量
		
		#velocity = direction_normal * speed, 不能这样写，不然会改变玩家的速度
		velocity = velocity.move_toward(direction_normal * speed, acceleration)

func _on_player_detect_area_2d_body_entered(body: Node2D) -> void:
	if body is Player or body is OnlinePlayer: #当进入监测区的东西是玩家时
		target = body
		
func take_damage():
	HP -= 1
	
	#下面想让史莱姆被攻击时，整个人变成了红色
	var flash_red_color: Color = Color(50, 0.5, 0.5)
	modulate = flash_red_color
	
	#代码建立计时器，这样就不用建立计时器了，延迟0.2秒
	await get_tree().create_timer(0.2).timeout
	
	var original_color: Color = Color(1, 1, 1)
	modulate = original_color
	
	if HP <= 0:
		die()
		
	play_damage_sfx()
		
func play_damage_sfx():
	$DamageSFX.play()
	
func die():
	$GPUParticles2D.emitting = true #死亡之后展示爆炸
	$AnimatedSprite2D.visible = false #死亡之后就不可见了
	$CollisionShape2D.set_deferred("disabled", true) #设置不可碰撞
	
	await get_tree().create_timer(1).timeout #延迟一秒钟，不然不会展示动画
	
	queue_free()
