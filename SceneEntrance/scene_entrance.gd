extends Area2D

@export var next_scene: String
@export var player_spawn_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		R.player_spawn_position = player_spawn_position
		print("The body has entered me")
		get_tree().change_scene_to_file.call_deferred(next_scene)
	


func _on_body_exited(body: Node2D) -> void:
	print("The body has exited me")
