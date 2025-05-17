# 作为全局单例 Music
extends Node

enum {
	CYCLE,
	NO_CYCLE
}

@export var is_cycled : bool = true	# 是否循环
var cur_time = 0.0

# 切换到指定曲目，并自动播放 目前这个方法只支持MP3, OGG
# 参数是路径 e.g. res://yuan_is_god.mp3
func switch(audio : AudioStream):
	cur_time = 0.0
	$AudioStreamPlayer.stream = audio
	play()

# 暂停音乐
func stop():
	cur_time = $AudioStreamPlayer.get_playback_position()
	$AudioStreamPlayer.stop()

# 继续音乐
func play():
	$AudioStreamPlayer.play(cur_time)
	
# 设置是否是循环, CYCLE | NO_CYCLE
func setCycle(x):
	if x == CYCLE:
		is_cycled = true
	elif x == NO_CYCLE:
		is_cycled = false
	
# 循环的判断,信号链接
func _on_audio_stream_player_finished() -> void:
	if is_cycled:
		$AudioStreamPlayer.play()
