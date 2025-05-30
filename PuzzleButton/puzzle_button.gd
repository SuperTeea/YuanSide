extends Area2D

var bodies_on_top: int = 0 #用来判断有多少个物体在按钮上
signal pressed
signal unpressed

@export var is_single_use: bool = false


func _on_body_entered(body: Node2D) -> void:
	bodies_on_top += 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 1:
			$AudioStreamPlayer2D.pitch_scale = 1.0
			$AudioStreamPlayer2D.play()
			pressed.emit()
			print("I have been pressed")
			$AnimatedSprite2D.play("Press")
	

func _on_body_exited(body: Node2D) -> void:
	if is_single_use:
		return
	bodies_on_top -= 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 0:
			$AudioStreamPlayer2D.pitch_scale = 0.8
			$AudioStreamPlayer2D.play()
			unpressed.emit()
			print("I am no longer pressed")
			$AnimatedSprite2D.play("UnPress")
