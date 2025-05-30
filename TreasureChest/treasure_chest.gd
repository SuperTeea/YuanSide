extends StaticBody2D

var can_interact: bool = false #用来判断是否能被交互，这个在player_1.gd中查看原理
var is_open: bool = false

@export var chest_name: String

func _ready() -> void:
	if chest_name in R.opened_chests:
		is_open = true
		$AnimatedSprite2D.play("open")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		#触碰了之后，就不能再触碰了，因为是单触发开关
		if not is_open: #防止多次触发
			open_chest()	
		
func open_chest():
	is_open = true
	$AnimatedSprite2D.play("open")
	$Sprite2D.visible = true #此时宝藏可以被看见
	$AudioStreamPlayer2D.play()
	$Timer.start() # 计时器开始计时
	R.opened_chests.append(chest_name)
	print(R.opened_chests)


func _on_timer_timeout() -> void:
	$Sprite2D.visible = false # 当计时器结束之后，宝藏将被隐藏
