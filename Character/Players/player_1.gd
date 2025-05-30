extends CharacterBody2D
class_name Player

#var move_speed = 100
@export var move_speed = 100
@export var push_strength: float = 10 #推力
@export var acceleration: float = 10

var is_attacking: bool = false #用来判断是否正在攻击，用来方便攻击的时候不走路
#var can_interat: bool = false #用来判断是否可以进行交互，防止边交互边打斗

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_treasure_label() #复活后更新
	update_hp_bar() #复活后更新生命值dd
	#从地牢出来的时候防止被重置，所以就要加上这个
	if R.player_spawn_position != Vector2(0, 0):
		position = R.player_spawn_position
	#Engine.max_fps = 15
	#R.player_hp = 3
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if R.player_hp <= 0:
		return
	
	if not is_attacking:
		move_player()
	
	push_blocks()
	
	update_treasure_label()
	
	#防止边攻击边对话
	if Input.is_action_just_pressed("attack"): 
		attack()
	
	move_and_slide()
	
func move_player():
	var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(move_vector * move_speed, acceleration)
	if velocity.x > 0:
		$AnimatedSprite2D.play("move_right")
		$InteractArea2D.position = Vector2(5, 1)
		
	elif velocity.x < 0:
		$AnimatedSprite2D.play("move_left")
		$InteractArea2D.position = Vector2(-5, 1)
		
	elif velocity.y > 0:
		$AnimatedSprite2D.play("move_down")
		$InteractArea2D.position = Vector2(0, 7)
		
	elif velocity.y < 0:
		$AnimatedSprite2D.play("move_up")
		$InteractArea2D.position = Vector2(0, -5)
		
	#if velocity == Vector2(0, 0):
	else:
		$AnimatedSprite2D.stop()

func push_blocks():
	#下面是关于人物推碰撞体模块，得到人物先碰撞的物品
	var collision: KinematicCollision2D = get_last_slide_collision()
	#必须如果碰撞了才有下面的步骤
	if collision:
		#得到碰撞节点的类型
		var collider_node = collision.get_collider()
		if collider_node.is_in_group("pushable"):
			#得到碰撞节点的向量
			var collision_normal: Vector2 = collision.get_normal()
			collider_node.apply_central_force(-collision_normal * push_strength)
		#if collider_node.is_in_group("wall"):
				#print("I am touching a wall")
	
func update_treasure_label():
	#$CanvasLayer/Panel/TreasureLabel 设置唯一化，就不用那么长的路径
	var treasure_amount: int = len(R.opened_chests)
	%TreasureLabel.text = str(treasure_amount)

#这是是建立连接的代码，代表当碰到的东西在这个组里，就触发条件
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		body.can_interact = true
		#can_interat = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		body.can_interact = false
		#can_interat = true


#当有敌人碰到玩家的这个碰撞区域时，就会发生
func _on_hit_box_area_2d_body_entered(body: Node2D) -> void:
	#get_tree().call_deferred("reload_current_scene")
	R.player_hp -= 1
	update_hp_bar()
	if R.player_hp <= 0:
		die()
		
	body.play_damage_sfx()
		
	var distance_to_player: Vector2 #玩家距离敌人的距离
	#玩家的位置减去史莱姆的位置
	distance_to_player = global_position - body.global_position
	var knockback_direction: Vector2 = distance_to_player.normalized() #方向向量
	
	var knockback_strength: float = 150
	
	velocity += knockback_direction * knockback_strength
	
	$DamageSFX.play()
	
	#下面想让玩家被攻击时，整个人变成了白色
	var flash_white_color: Color = Color(50, 50, 50)
	modulate = flash_white_color
	
	#代码建立计时器，这样就不用建立计时器了，延迟0.2秒
	await get_tree().create_timer(0.2).timeout
	
	var original_color: Color = Color(1, 1, 1)
	modulate = original_color
	
#玩家死亡函数
func die():
	$AnimatedSprite2D.play("death") #死了之后播放死亡动画
	if $DeathTimer.is_stopped(): #如果计时器停止，就开始
		$DeathTimer.start()
	
#当计时器时间结束之后，场景初始化
func _on_death_timer_timeout() -> void:
	R.player_hp = 3 #恢复血量
	get_tree().call_deferred("reload_current_scene")	#复活
	
func update_hp_bar():
	#加载生命值的代码
	if R.player_hp == 3:
		%HPBar.play("3_hp")
	elif R.player_hp == 2:
		%HPBar.play("2_hp")
	elif R.player_hp == 1:
		%HPBar.play("1_hp")
	else:
		%HPBar.play("0_hp")
		
func attack():
	#如果计时器正在运行，就直接返回，防止每次都要等到0.4结束卡顿
	if not $AttackDurationTimer.is_stopped():
		return
	
	$SwordSFX.play() 
	#展示大刀
	$Sword.visible = true
	%SwordArea2D.monitoring = true #大刀可以使用
	$AttackDurationTimer.start() #计时器开始计时
	is_attacking = true
	velocity = Vector2(0, 0)
	
	#将状态设置为挥砍
	var player_animation: String = $AnimatedSprite2D.animation
	if player_animation == "move_right":
		$AnimatedSprite2D.play("attack_right")
		$AnimationPlayer.play("attack_right")
	elif player_animation == "move_left":
		$AnimatedSprite2D.play("attack_left")
		$AnimationPlayer.play("attack_left")
	elif player_animation == "move_up":
		$AnimatedSprite2D.play("attack_up")
		$AnimationPlayer.play("attack_up")
	elif player_animation == "move_down":
		$AnimatedSprite2D.play("attack_down")
		$AnimationPlayer.play("attack_down")


func _on_sword_area_2d_body_entered(body: Node2D) -> void:
	var distance_to_enemy: Vector2 #玩家距离敌人的距离
	#玩家的位置减去史莱姆的位置
	distance_to_enemy = body.global_position - global_position
	var knockback_direction: Vector2 = distance_to_enemy.normalized() #方向向量
	
	var knockback_strength: float = 150
	
	body.velocity += knockback_direction * knockback_strength
	
	body.take_damage()
		
	


func _on_attack_duration_timer_timeout() -> void:
	$Sword.visible = false
	%SwordArea2D.monitoring = false
	is_attacking = false
	
	#防止每次攻击之后动作都保持在攻击后的效果
	var player_animation: String = $AnimatedSprite2D.animation
	if player_animation == "attack_right":
		$AnimatedSprite2D.play("move_right")
	elif player_animation == "attack_left":
		$AnimatedSprite2D.play("move_left")
	elif player_animation == "attack_up":
		$AnimatedSprite2D.play("move_up")
	elif player_animation == "attack_down":
		$AnimatedSprite2D.play("move_down")
