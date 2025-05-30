extends StaticBody2D

var can_interact: bool = false
@export var dialogue_lines: Array[String] = ["你看看你后面呢", "你再看看你后面呢", "你看看呗"]
var dialogue_index: int = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		$AudioStreamPlayer2D.play()
		if dialogue_index < len(dialogue_lines):
			$CanvasLayer.visible = true
			get_tree().paused = true
			$CanvasLayer/DialogueLabel.text = dialogue_lines[dialogue_index]
			dialogue_index += 1
		else:
			$CanvasLayer.visible = false
			get_tree().paused = false
			dialogue_index = 0
		
