extends Control

func _ready() -> void:
	Music.setCycle(Music.NO_CYCLE)
	Music.switch('res://Musics/Main_Theme.ogg')

func _on_play_pressed() -> void:
	Music.play()
	
func _on_stop_pressed() -> void:
	Music.stop()
	var item = ResourceLoader.load("res://Items/health_potion.tres") as BaseItem
	
func _process(delta: float) -> void:
	$Label.text = "hp : " + str(R.user.hp)


func _on_add_hp_pressed() -> void:
	R.modify_health(1)


func _on_save_pressed() -> void:
	R.user.save_profile()


func _on_load_pressed() -> void:
	R.user.load_profile()
