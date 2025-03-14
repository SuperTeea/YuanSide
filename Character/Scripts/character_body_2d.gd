class_name Player extends CharacterBody2D

var move_speed : float = 114.0
var state : String = 'walk'
var direction : Vector2 = Vector2.ZERO
var dir : String = 'down'
var dir_map = ['up', 'down', 'left', 'right']
var curAnimationpos = 0

@onready var animation : AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	
	direction.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	direction.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	
	velocity = direction * move_speed
	
	if SetState() || SetDir():
		var state_animate = state + '_' + dir if state != 'idle' else 'walk' + '_' + dir
		if state == 'idle':
			animation.pause()
		else:
			animation.play(state_animate)
		
func SetState() -> bool:
	var currentState = 'idle' if direction == Vector2.ZERO else 'walk'
	if currentState == state:
		return false
	state = currentState
	return true
	
func SetDir() -> bool:
	var arr : Array = [Input.get_action_strength('up'), Input.get_action_strength('down'), Input.get_action_strength('left'), Input.get_action_strength('right')]
	var maxx = arr.max()
	#print(maxx)
	var curdir = dir_map[arr.find(maxx)]
	if curdir == dir || maxx == 0.0:
		return false
	dir = curdir
	return true
	
func _physics_process(delta: float) -> void:
	move_and_slide()
