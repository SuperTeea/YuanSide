extends StaticBody2D

var can_interact: bool = false
var is_activated: bool = false


signal switch_activated
signal switch_deactivated

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		$AudioStreamPlayer2D.play()
		if is_activated:
			deactivate_switch()
		else:
			activate_switch()
			
#打开开关
func activate_switch():
	$AnimatedSprite2D.play("activated")
	switch_activated.emit() #与该信号相连的信号都被触发 
	is_activated = true
	
#关闭开关
func deactivate_switch():
	$AnimatedSprite2D.play("deactivated")
	switch_deactivated.emit()
	is_activated = false
